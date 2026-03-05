const Redis = require('redis');
const { promisify } = require('util');

class RedisClient {
  constructor() {
    this.client = null;
  }

  async connect() {
    try {
      this.client = Redis.createClient({
        host: process.env.REDIS_HOST || 'localhost',
        port: process.env.REDIS_PORT || 6379,
        password: process.env.REDIS_PASSWORD || undefined
      });

      this.client.on('error', (err) => {
        console.error(`❌ Redis 错误：${err.message}`);
      });

      this.client.on('connect', () => {
        console.log('✅ Redis 连接成功');
      });

      await this.client.connect();
      
      // Promisify 常用方法
      this.get = promisify(this.client.get).bind(this.client);
      this.set = promisify(this.client.set).bind(this.client);
      this.del = promisify(this.client.del).bind(this.client);
      this.lpush = promisify(this.client.lpush).bind(this.client);
      this.rpush = promisify(this.client.rpush).bind(this.client);
      this.lrange = promisify(this.client.lrange).bind(this.client);
      this.sadd = promisify(this.client.sadd).bind(this.client);
      this.smembers = promisify(this.client.smembers).bind(this.client);
      this.hset = promisify(this.client.hSet).bind(this.client);
      this.hget = promisify(this.client.hGet).bind(this.client);
      this.hgetall = promisify(this.client.hGetAll).bind(this.client);
      this.publish = promisify(this.client.publish).bind(this.client);
      this.subscribe = this.client.subscribe.bind(this.client);
      
      return this.client;
    } catch (error) {
      console.error(`❌ Redis 连接失败：${error.message}`);
      throw error;
    }
  }

  // 存储用户在线状态
  async setUserOnline(userId, socketId) {
    await this.sadd(`user:${userId}:sockets`, socketId);
    await this.set(`user:${userId}:status`, 'online');
  }

  // 移除用户在线状态
  async setUserOffline(userId, socketId) {
    if (socketId) {
      await this.client.sRem(`user:${userId}:sockets`, socketId);
    }
    const sockets = await this.client.sMembers(`user:${userId}:sockets`);
    if (sockets.length === 0) {
      await this.set(`user:${userId}:status`, 'offline');
    }
  }

  // 获取用户状态
  async getUserStatus(userId) {
    return await this.get(`user:${userId}:status`);
  }

  // 获取用户 socket IDs
  async getUserSockets(userId) {
    return await this.client.sMembers(`user:${userId}:sockets`);
  }

  // 存储未读消息
  async addUnreadMessage(userId, messageId) {
    await this.lpush(`user:${userId}:unread`, messageId);
    await this.client.lTrim(`user:${userId}:unread`, 0, 99); // 最多保留 100 条
  }

  // 获取未读消息数量
  async getUnreadCount(userId) {
    return await this.client.lLen(`user:${userId}:unread`);
  }

  // 清除未读消息
  async clearUnreadMessages(userId) {
    await this.del(`user:${userId}:unread`);
  }
}

module.exports = new RedisClient();
