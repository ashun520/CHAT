const User = require('../models/User');
const Conversation = require('../models/Conversation');

// 获取好友列表
exports.getFriends = async (req, res) => {
  try {
    const user = await User.findById(req.user._id)
      .populate('friends', 'username nickname avatar gender signature status lastSeen')
      .select('friends');

    res.json({
      success: true,
      data: user.friends
    });
  } catch (error) {
    console.error('获取好友列表错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 搜索用户
exports.searchUsers = async (req, res) => {
  try {
    const { keyword, type } = req.query;

    if (!keyword) {
      return res.status(400).json({
        success: false,
        message: '请输入搜索关键词'
      });
    }

    let query;
    switch (type) {
      case 'email':
        query = { email: new RegExp(keyword, 'i') };
        break;
      case 'phone':
        query = { phone: new RegExp(keyword, 'i') };
        break;
      case 'username':
        query = { username: new RegExp(keyword, 'i') };
        break;
      default:
        query = {
          $or: [
            { username: new RegExp(keyword, 'i') },
            { email: new RegExp(keyword, 'i') },
            { phone: new RegExp(keyword, 'i') }
          ]
        };
    }

    // 排除自己和黑名单用户
    const users = await User.find(query)
      .where('_id').ne(req.user._id)
      .where('_id').nin(req.user.blackList)
      .select('username nickname avatar gender signature status lastSeen')
      .limit(20);

    res.json({
      success: true,
      data: users.map(user => user.toPublicJSON())
    });
  } catch (error) {
    console.error('搜索用户错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 发送好友请求
exports.sendFriendRequest = async (req, res) => {
  try {
    const { userId, message } = req.body;

    if (userId.toString() === req.user._id.toString()) {
      return res.status(400).json({
        success: false,
        message: '不能添加自己为好友'
      });
    }

    const targetUser = await User.findById(userId);

    if (!targetUser) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }

    // 检查是否已是好友
    if (targetUser.friends.includes(req.user._id)) {
      return res.status(400).json({
        success: false,
        message: '已经是好友了'
      });
    }

    // 检查是否在黑名单
    if (targetUser.blackList.includes(req.user._id)) {
      return res.status(403).json({
        success: false,
        message: '你已被对方加入黑名单'
      });
    }

    // 检查是否已发送过请求
    const existingRequest = targetUser.friendRequests.find(
      req => req.from.toString() === req.user._id.toString() && req.status === 'pending'
    );

    if (existingRequest) {
      return res.status(400).json({
        success: false,
        message: '好友请求已发送，请等待对方处理'
      });
    }

    // 添加好友请求
    await User.findByIdAndUpdate(userId, {
      $push: {
        friendRequests: {
          from: req.user._id,
          message: message || ''
        }
      }
    });

    res.json({
      success: true,
      message: '好友请求已发送'
    });
  } catch (error) {
    console.error('发送好友请求错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 获取好友请求列表
exports.getFriendRequests = async (req, res) => {
  try {
    const user = await User.findById(req.user._id)
      .populate('friendRequests.from', 'username nickname avatar gender signature');

    const pendingRequests = user.friendRequests.filter(
      req => req.status === 'pending'
    );

    res.json({
      success: true,
      data: pendingRequests
    });
  } catch (error) {
    console.error('获取好友请求错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 处理好友请求
exports.handleFriendRequest = async (req, res) => {
  try {
    const { requestId, action } = req.body; // action: 'accept' or 'reject'

    const user = await User.findById(req.user._id);
    const request = user.friendRequests.id(requestId);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: '好友请求不存在'
      });
    }

    if (request.status !== 'pending') {
      return res.status(400).json({
        success: false,
        message: '请求已处理'
      });
    }

    const requesterId = request.from;

    if (action === 'accept') {
      // 互相添加为好友
      await Promise.all([
        User.findByIdAndUpdate(req.user._id, {
          $addToSet: { friends: requesterId },
          $set: { 'friendRequests.$[elem].status': 'accepted' }
        }, {
          arrayFilters: [{ 'elem._id': requestId }]
        }),
        User.findByIdAndUpdate(requesterId, {
          $addToSet: { friends: req.user._id }
        })
      ]);

      // 创建会话
      await Conversation.findOneAndUpdate(
        {
          type: 'private',
          participants: { $all: [req.user._id, requesterId] }
        },
        {
          $setOnInsert: {
            participants: [req.user._id, requesterId]
          }
        },
        { upsert: true, new: true }
      );

      res.json({
        success: true,
        message: '已接受好友请求'
      });
    } else if (action === 'reject') {
      await User.findByIdAndUpdate(req.user._id, {
        $set: { 'friendRequests.$[elem].status': 'rejected' }
      }, {
        arrayFilters: [{ 'elem._id': requestId }]
      });

      res.json({
        success: true,
        message: '已拒绝好友请求'
      });
    } else {
      return res.status(400).json({
        success: false,
        message: '无效的操作'
      });
    }
  } catch (error) {
    console.error('处理好友请求错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 删除好友
exports.removeFriend = async (req, res) => {
  try {
    const { friendId } = req.params;

    await Promise.all([
      User.findByIdAndUpdate(req.user._id, {
        $pull: { friends: friendId }
      }),
      User.findByIdAndUpdate(friendId, {
        $pull: { friends: req.user._id }
      })
    ]);

    res.json({
      success: true,
      message: '好友已删除'
    });
  } catch (error) {
    console.error('删除好友错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 加入黑名单
exports.addToBlackList = async (req, res) => {
  try {
    const { userId } = req.body;

    if (userId.toString() === req.user._id.toString()) {
      return res.status(400).json({
        success: false,
        message: '不能将自己加入黑名单'
      });
    }

    await User.findByIdAndUpdate(req.user._id, {
      $addToSet: { blackList: userId },
      $pull: { friends: userId }
    });

    // 同时从对方的好友列表中移除自己
    await User.findByIdAndUpdate(userId, {
      $pull: { friends: req.user._id }
    });

    res.json({
      success: true,
      message: '已加入黑名单'
    });
  } catch (error) {
    console.error('加入黑名单错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 从黑名单移除
exports.removeFromBlackList = async (req, res) => {
  try {
    const { userId } = req.params;

    await User.findByIdAndUpdate(req.user._id, {
      $pull: { blackList: userId }
    });

    res.json({
      success: true,
      message: '已从黑名单移除'
    });
  } catch (error) {
    console.error('移除黑名单错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};
