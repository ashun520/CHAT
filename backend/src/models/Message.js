const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  conversationId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    index: true
  },
  conversationType: {
    type: String,
    enum: ['private', 'group'],
    required: true
  },
  sender: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  receiver: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  group: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Group'
  },
  type: {
    type: String,
    enum: ['text', 'image', 'video', 'audio', 'file', 'emoji', 'system', 'location', 'contact', 'voice_call', 'video_call'],
    required: true
  },
  content: {
    text: String,
    imageUrl: String,
    videoUrl: String,
    audioUrl: String,
    fileName: String,
    fileSize: Number,
    filePath: String,
    emojiCode: String,
    duration: Number,
    latitude: Number,
    longitude: Number,
    locationName: String,
    contactInfo: {
      userId: mongoose.Schema.Types.ObjectId,
      name: String,
      avatar: String
    }
  },
  status: {
    type: String,
    enum: ['sending', 'sent', 'delivered', 'read', 'failed'],
    default: 'sending'
  },
  readBy: [{
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    readAt: {
      type: Date,
      default: Date.now
    }
  }],
  deliveredTo: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  mentions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  replyTo: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message'
  },
  isDeleted: {
    type: Boolean,
    default: false
  },
  deletedAt: Date,
  edited: {
    type: Boolean,
    default: false
  },
  editedAt: Date
}, {
  timestamps: true
});

// 索引优化查询
messageSchema.index({ conversationId: 1, createdAt: -1 });
messageSchema.index({ sender: 1, createdAt: -1 });
messageSchema.index({ receiver: 1, createdAt: -1 });

module.exports = mongoose.model('Message', messageSchema);
