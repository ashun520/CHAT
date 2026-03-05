const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    minlength: 3,
    maxlength: 30
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  password: {
    type: String,
    required: true,
    minlength: 6
  },
  avatar: {
    type: String,
    default: ''
  },
  nickname: {
    type: String,
    default: ''
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other'
  },
  birthday: {
    type: Date
  },
  signature: {
    type: String,
    default: '',
    maxlength: 100
  },
  status: {
    type: String,
    enum: ['online', 'offline', 'away', 'busy', 'invisible'],
    default: 'offline'
  },
  lastSeen: {
    type: Date,
    default: Date.now
  },
  friends: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  friendRequests: [{
    from: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    message: String,
    status: {
      type: String,
      enum: ['pending', 'accepted', 'rejected'],
      default: 'pending'
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }],
  blackList: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  groups: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group'
  }],
  settings: {
    notifyMessage: {
      type: Boolean,
      default: true
    },
    notifySound: {
      type: Boolean,
      default: true
    },
    notifyVibrate: {
      type: Boolean,
      default: true
    },
    allowInvite: {
      type: Boolean,
      default: true
    },
    allowFindbyPhone: {
      type: Boolean,
      default: true
    },
    allowFindbyEmail: {
      type: Boolean,
      default: true
    }
  },
  fcmToken: {
    type: String,
    default: ''
  }
}, {
  timestamps: true
});

// 密码加密
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// 密码验证
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// 生成公开信息
userSchema.methods.toPublicJSON = function() {
  return {
    id: this._id,
    username: this.username,
    email: this.email,
    phone: this.phone,
    avatar: this.avatar,
    nickname: this.nickname || this.username,
    gender: this.gender,
    signature: this.signature,
    status: this.status,
    lastSeen: this.lastSeen
  };
};

module.exports = mongoose.model('User', userSchema);
