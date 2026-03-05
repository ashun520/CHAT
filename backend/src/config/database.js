const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log(`✅ MongoDB 连接成功：${conn.connection.host}`);
    
    // 监听连接事件
    mongoose.connection.on('error', (err) => {
      console.error(`❌ MongoDB 错误：${err.message}`);
    });

    mongoose.connection.on('disconnected', () => {
      console.warn('⚠️  MongoDB 断开连接');
    });

    // 优雅关闭
    process.on('SIGINT', async () => {
      await mongoose.connection.close();
      console.log('MongoDB 连接已关闭');
      process.exit(0);
    });

    return conn;
  } catch (error) {
    console.error(`❌ MongoDB 连接失败：${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
