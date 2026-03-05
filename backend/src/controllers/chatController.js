const Message = require('../models/Message');
const Conversation = require('../models/Conversation');
const User = require('../models/User');
const redisClient = require('../config/redis');

// 获取会话列表
exports.getConversations = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const skip = (page - 1) * limit;

    // 查找用户参与的所有会话
    const conversations = await Conversation.find({
      participants: req.user._id
    })
    .populate('lastMessage', 'type content createdAt sender')
    .populate('participants', 'username nickname avatar status lastSeen')
    .sort({ lastMessageAt: -1 })
    .limit(limit * 1)
    .skip(skip)
    .lean();

    const count = await Conversation.countDocuments({
      participants: req.user._id
    });

    // 添加未读消息数
    const conversationsWithUnread = await Promise.all(
      conversations.map(async (conv) => {
        const unreadCount = conv.unreadCount.get(req.user._id.toString()) || 0;
        return { ...conv, unreadCount };
      })
    );

    res.json({
      success: true,
      data: conversationsWithUnread,
      pagination: {
        total: count,
        page: parseInt(page),
        pages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('获取会话列表错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 获取聊天记录
exports.getMessages = async (req, res) => {
  try {
    const { conversationId, page = 1, limit = 50 } = req.query;
    const skip = (page - 1) * limit;

    const messages = await Message.find({
      conversationId,
      isDeleted: false
    })
    .populate('sender', 'username nickname avatar')
    .populate('replyTo', 'type content sender')
    .sort({ createdAt: -1 })
    .limit(limit * 1)
    .skip(skip)
    .lean();

    const count = await Message.countDocuments({
      conversationId,
      isDeleted: false
    });

    res.json({
      success: true,
      data: messages.reverse(), // 按时间正序排列
      pagination: {
        total: count,
        page: parseInt(page),
        pages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('获取聊天记录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 标记消息为已读
exports.markAsRead = async (req, res) => {
  try {
    const { conversationId } = req.body;

    await Message.updateMany(
      {
        conversationId,
        receiver: req.user._id,
        status: { $in: ['sent', 'delivered'] }
      },
      {
        $set: { status: 'read' },
        $push: {
          readBy: {
            user: req.user._id,
            readAt: new Date()
          }
        }
      }
    );

    // 更新会话未读数
    await Conversation.findOneAndUpdate(
      { _id: conversationId },
      {
        $unset: { [`unreadCount.${req.user._id}`]: '' }
      }
    );

    res.json({
      success: true,
      message: '消息已标记为已读'
    });
  } catch (error) {
    console.error('标记已读错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 删除消息
exports.deleteMessage = async (req, res) => {
  try {
    const { messageId } = req.params;

    const message = await Message.findOne({
      _id: messageId,
      $or: [
        { sender: req.user._id },
        { receiver: req.user._id }
      ]
    });

    if (!message) {
      return res.status(404).json({
        success: false,
        message: '消息不存在'
      });
    }

    // 只能删除自己的消息
    if (message.sender.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权删除此消息'
      });
    }

    message.isDeleted = true;
    message.deletedAt = new Date();
    await message.save();

    res.json({
      success: true,
      message: '消息已删除'
    });
  } catch (error) {
    console.error('删除消息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};
