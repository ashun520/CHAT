const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Message = require('../models/Message');
const Conversation = require('../models/Conversation');
const Group = require('../models/Group');
const redisClient = require('../config/redis');

// Socket.IO 中间件 - 认证
const socketAuthMiddleware = async (socket, next) => {
  try {
    const token = socket.handshake.auth.token;
    
    if (!token) {
      return next(new Error('认证令牌缺失'));
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId).select('-password');

    if (!user) {
      return next(new Error('用户不存在'));
    }

    socket.user = user;
    next();
  } catch (error) {
    next(new Error('认证失败'));
  }
};

// 初始化 Socket.IO
const initializeSocket = (io) => {
  // 应用认证中间件
  io.use(socketAuthMiddleware);

  io.on('connection', async (socket) => {
    console.log(`🔌 用户连接：${socket.user.username} (${socket.id})`);

    const userId = socket.user._id.toString();

    try {
      // 更新用户状态为在线
      await User.findByIdAndUpdate(userId, {
        status: 'online',
        lastSeen: new Date()
      });

      // 存储用户 socket 连接
      await redisClient.setUserOnline(userId, socket.id);

      // 加入个人房间
      socket.join(`user:${userId}`);

      // 通知好友上线
      const user = await User.findById(userId).populate('friends', 'username nickname avatar status');
      const friendIds = user.friends.map(f => f._id.toString());
      
      for (const friendId of friendIds) {
        const friendSockets = await redisClient.getUserSockets(friendId);
        for (const friendSocket of friendSockets) {
          io.to(friendSocket).emit('user:online', {
            userId,
            username: socket.user.username,
            avatar: socket.user.avatar
          });
        }
      }

      // 加入所有群聊房间
      const groups = await Group.find({
        'members.user': userId,
        'members.isDeleted': false
      });

      for (const group of groups) {
        socket.join(`group:${group._id}`);
      }

      // ===== 聊天消息处理 =====
      
      // 发送消息
      socket.on('message:send', async (data, callback) => {
        try {
          const { conversationId, type, content, receiverId, groupId, replyTo, mentions } = data;

          // 创建消息
          const message = new Message({
            conversationId,
            conversationType: groupId ? 'group' : 'private',
            sender: userId,
            receiver: receiverId,
            group: groupId,
            type,
            content,
            replyTo,
            mentions,
            status: 'sent'
          });

          await message.save();

          // 更新或创建会话
          let conversation = await Conversation.findById(conversationId);
          
          if (!conversation) {
            conversation = new Conversation({
              type: groupId ? 'group' : 'private',
              participants: groupId ? [] : [userId, receiverId],
              group: groupId,
              lastMessage: message._id,
              lastMessageAt: message.createdAt
            });
            await conversation.save();
          } else {
            conversation.lastMessage = message._id;
            conversation.lastMessageAt = message.createdAt;
            await conversation.save();
          }

          // 更新未读消息数
          if (groupId) {
            const group = await Group.findById(groupId);
            const memberIds = group.members
              .filter(m => !m.isDeleted && m.user.toString() !== userId)
              .map(m => m.user.toString());
            
            for (const memberId of memberIds) {
              const key = `unreadCount.${memberId}`;
              await Conversation.findByIdAndUpdate(conversationId, {
                $inc: { [key]: 1 }
              });
            }
          } else {
            await Conversation.findOneAndUpdate(
              {
                type: 'private',
                participants: { $all: [userId, receiverId] }
              },
              {
                $inc: { [`unreadCount.${receiverId}`]: 1 }
              }
            );
          }

          // 填充发送者信息
          await message.populate('sender', 'username nickname avatar');

          // 广播消息
          if (groupId) {
            // 群聊消息
            io.to(`group:${groupId}`).emit('message:new', {
              conversationId,
              message
            });
          } else {
            // 私聊消息
            const receiverSockets = await redisClient.getUserSockets(receiverId);
            for (const receiverSocket of receiverSockets) {
              io.to(receiverSocket).emit('message:new', {
                conversationId,
                message
              });
            }
          }

          // 发送给发送者确认
          io.to(`user:${userId}`).emit('message:sent', {
            conversationId,
            message
          });

          // 更新会话列表
          io.to(`user:${userId}`).emit('conversation:update', {
            conversation
          });

          if (typeof callback === 'function') {
            callback({ success: true, messageId: message._id });
          }
        } catch (error) {
          console.error('发送消息错误:', error);
          if (typeof callback === 'function') {
            callback({ success: false, error: '发送失败' });
          }
        }
      });

      // 消息已读确认
      socket.on('message:read', async (data) => {
        try {
          const { conversationId } = data;

          await Message.updateMany(
            {
              conversationId,
              receiver: userId,
              status: { $in: ['sent', 'delivered'] }
            },
            {
              $set: { status: 'read' },
              $push: {
                readBy: {
                  user: userId,
                  readAt: new Date()
                }
              }
            }
          );

          // 清除未读计数
          await Conversation.findOneAndUpdate(
            { _id: conversationId },
            {
              $unset: { [`unreadCount.${userId}`]: '' }
            }
          );

          // 通知发送者消息已读
          const messages = await Message.find({ conversationId }).select('sender');
          const senderIds = [...new Set(messages.map(m => m.sender.toString()))];

          for (const senderId of senderIds) {
            if (senderId !== userId) {
              const senderSockets = await redisClient.getUserSockets(senderId);
              for (const senderSocket of senderSockets) {
                io.to(senderSocket).emit('message:read', {
                  conversationId,
                  readerId: userId
                });
              }
            }
          }
        } catch (error) {
          console.error('标记已读错误:', error);
        }
      });

      // 输入状态
      socket.on('typing:start', async (data) => {
        const { conversationId } = data;
        
        if (data.groupId) {
          socket.to(`group:${data.groupId}`).emit('typing:update', {
            conversationId,
            userId,
            username: socket.user.username,
            isTyping: true
          });
        } else {
          const receiverSockets = await redisClient.getUserSockets(data.receiverId);
          for (const receiverSocket of receiverSockets) {
            io.to(receiverSocket).emit('typing:update', {
              conversationId,
              userId,
              username: socket.user.username,
              isTyping: true
            });
          }
        }
      });

      socket.on('typing:end', async (data) => {
        const { conversationId } = data;
        
        if (data.groupId) {
          socket.to(`group:${data.groupId}`).emit('typing:update', {
            conversationId,
            userId,
            username: socket.user.username,
            isTyping: false
          });
        } else {
          const receiverSockets = await redisClient.getUserSockets(data.receiverId);
          for (const receiverSocket of receiverSockets) {
            io.to(receiverSocket).emit('typing:update', {
              conversationId,
              userId,
              username: socket.user.username,
              isTyping: false
            });
          }
        }
      });

      // ===== 群聊管理 =====
      
      socket.on('group:create', async (data, callback) => {
        try {
          const { name, avatar, memberIds } = data;

          const group = new Group({
            name,
            avatar,
            owner: userId,
            members: [
              { user: userId, role: 'owner' },
              ...memberIds.map(id => ({ user: id, role: 'member' }))
            ]
          });

          await group.save();

          // 更新用户的群组列表
          await User.findByIdAndUpdate(userId, {
            $addToSet: { groups: group._id }
          });

          // 通知成员
          for (const memberId of memberIds) {
            await User.findByIdAndUpdate(memberId, {
              $addToSet: { groups: group._id }
            });
            const memberSockets = await redisClient.getUserSockets(memberId);
            for (const memberSocket of memberSockets) {
              io.to(memberSocket).emit('group:invite', { group });
            }
          }

          // 加入群聊房间
          socket.join(`group:${group._id}`);

          if (typeof callback === 'function') {
            callback({ success: true, groupId: group._id });
          }
        } catch (error) {
          console.error('创建群聊错误:', error);
          if (typeof callback === 'function') {
            callback({ success: false, error: '创建失败' });
          }
        }
      });

      // ===== 断开连接 =====
      
      socket.on('disconnect', async () => {
        console.log(`🔌 用户断开：${socket.user.username} (${socket.id})`);

        // 移除 socket 连接
        await redisClient.setUserOffline(userId, socket.id);

        // 检查是否还有其他连接
        const status = await redisClient.getUserStatus(userId);
        if (status === 'offline') {
          await User.findByIdAndUpdate(userId, {
            status: 'offline',
            lastSeen: new Date()
          });

          // 通知好友下线
          const user = await User.findById(userId).populate('friends');
          const friendIds = user.friends.map(f => f._id.toString());
          
          for (const friendId of friendIds) {
            const friendSockets = await redisClient.getUserSockets(friendId);
            for (const friendSocket of friendSockets) {
              io.to(friendSocket).emit('user:offline', {
                userId,
                username: socket.user.username
              });
            }
          }
        }

        socket.leave(`user:${userId}`);
      });

    } catch (error) {
      console.error('Socket 连接错误:', error);
    }
  });
};

module.exports = initializeSocket;
