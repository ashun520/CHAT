const mongoose = require('mongoose');

const groupSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    maxlength: 50
  },
  avatar: {
    type: String,
    default: ''
  },
  owner: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  members: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    role: {
      type: String,
      enum: ['owner', 'admin', 'member'],
      default: 'member'
    },
    joinedAt: {
      type: Date,
      default: Date.now
    },
    nickname: {
      type: String,
      default: ''
    },
    isMuted: {
      type: Boolean,
      default: false
    },
    isDeleted: {
      type: Boolean,
      default: false
    }
  }],
  announcement: {
    content: String,
    publisher: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    publishedAt: Date
  },
  settings: {
    onlyOwnerCanPost: {
      type: Boolean,
      default: false
    },
    onlyMembersCanJoin: {
      type: Boolean,
      default: false
    },
    maxMembers: {
      type: Number,
      default: 500
    }
  },
  type: {
    type: String,
    enum: ['private', 'public', 'restricted'],
    default: 'private'
  },
  isDeleted: {
    type: Boolean,
    default: false
  },
  deletedAt: Date
}, {
  timestamps: true
});

// 索引优化
groupSchema.index({ owner: 1 });
groupSchema.index({ 'members.user': 1 });

// 获取成员列表
groupSchema.methods.getMembers = function() {
  return this.members.filter(m => !m.isDeleted).map(m => m.user);
};

// 获取成员数量
groupSchema.methods.getMemberCount = function() {
  return this.members.filter(m => !m.isDeleted).length;
};

// 检查用户是否是成员
groupSchema.methods.isMember = function(userId) {
  return this.members.some(m => m.user.toString() === userId.toString() && !m.isDeleted);
};

// 检查用户是否是管理员或群主
groupSchema.methods.isAdmin = function(userId) {
  const member = this.members.find(m => m.user.toString() === userId.toString() && !m.isDeleted);
  return member && (member.role === 'admin' || member.role === 'owner');
};

module.exports = mongoose.model('Group', groupSchema);
