require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const path = require('path');

const connectDB = require('./config/database');
const redisClient = require('./config/redis');
const initializeSocket = require('./socket/socketHandler');

// 导入路由
const authRoutes = require('./routes/auth');
const chatRoutes = require('./routes/chat');
const friendRoutes = require('./routes/friends');
const uploadRoutes = require('./routes/upload');

// 创建 Express 应用
const app = express();
const server = http.createServer(app);

// 创建 Socket.IO 服务器
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  },
  pingTimeout: 60000,
  pingInterval: 25000
});

// 中间件
app.use(helmet()); // 安全头
app.use(cors()); // 跨域
app.use(compression()); // Gzip 压缩
app.use(morgan('dev')); // 日志
app.use(express.json()); // JSON 解析
app.use(express.urlencoded({ extended: true })); // URL 编码解析

// 静态文件服务（上传的文件）
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// API 路由
app.use('/api/auth', authRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/friends', friendRoutes);
app.use('/api/upload', uploadRoutes);

// 健康检查
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// 404 处理
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: '接口不存在'
  });
});

// 错误处理
app.use((err, req, res, next) => {
  console.error('服务器错误:', err);
  res.status(500).json({
    success: false,
    message: process.env.NODE_ENV === 'development' ? err.message : '服务器内部错误'
  });
});

// 初始化 Socket.IO
initializeSocket(io);

// 启动服务器
const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    // 连接数据库
    await connectDB();
    
    // 连接 Redis
    await redisClient.connect();

    // 启动 HTTP 服务器
    server.listen(PORT, () => {
      console.log(`
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   🚀 SuperChat 服务器已启动！                              ║
║                                                           ║
║   端口：${PORT}                                            ║
║   环境：${process.env.NODE_ENV || 'development'}                              ║
║                                                           ║
║   API: http://localhost:${PORT}/api                       ║
║   Socket.IO: ws://localhost:${PORT}                       ║
║   健康检查：http://localhost:${PORT}/health               ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
      `);
    });
  } catch (error) {
    console.error('服务器启动失败:', error);
    process.exit(1);
  }
};

startServer();

// 优雅关闭
process.on('SIGTERM', () => {
  console.log('收到 SIGTERM 信号，正在关闭服务器...');
  server.close(() => {
    console.log('服务器已关闭');
    process.exit(0);
  });
});

module.exports = { app, io };
