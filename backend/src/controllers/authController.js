const jwt = require('jsonwebtoken');
const { validationResult } = require('express-validator');
const User = require('../models/User');

// 生成 JWT token
const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '7d'
  });
};

// 用户注册
exports.register = async (req, res) => {
  try {
    // 验证输入
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { username, email, phone, password } = req.body;

    // 检查用户是否已存在
    const existingUser = await User.findOne({
      $or: [{ email }, { phone }, { username }]
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: '用户名、邮箱或手机号已被使用'
      });
    }

    // 创建用户
    const user = new User({
      username,
      email,
      phone,
      password,
      nickname: username
    });

    await user.save();

    // 生成 token
    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: '注册成功',
      data: {
        token,
        user: user.toPublicJSON()
      }
    });
  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 用户登录
exports.login = async (req, res) => {
  try {
    // 验证输入
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { account, password } = req.body;

    // 查找用户（支持邮箱/手机号/用户名登录）
    const user = await User.findOne({
      $or: [
        { email: account },
        { phone: account },
        { username: account }
      ]
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: '账号或密码错误'
      });
    }

    // 验证密码
    const isMatch = await user.comparePassword(password);
    
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: '账号或密码错误'
      });
    }

    // 更新用户状态
    user.status = 'online';
    user.lastSeen = new Date();
    await user.save();

    // 生成 token
    const token = generateToken(user._id);

    res.json({
      success: true,
      message: '登录成功',
      data: {
        token,
        user: user.toPublicJSON()
      }
    });
  } catch (error) {
    console.error('登录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 获取用户信息
exports.getUserInfo = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select('-password');
    
    res.json({
      success: true,
      data: user.toPublicJSON()
    });
  } catch (error) {
    console.error('获取用户信息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 更新用户信息
exports.updateUserInfo = async (req, res) => {
  try {
    const allowedFields = ['nickname', 'avatar', 'gender', 'birthday', 'signature', 'settings'];
    const updates = {};

    Object.keys(req.body).forEach(key => {
      if (allowedFields.includes(key)) {
        updates[key] = req.body[key];
      }
    });

    const user = await User.findByIdAndUpdate(
      req.user._id,
      { $set: updates },
      { new: true, runValidators: true }
    ).select('-password');

    res.json({
      success: true,
      message: '更新成功',
      data: user.toPublicJSON()
    });
  } catch (error) {
    console.error('更新用户信息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 修改密码
exports.changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;

    // 验证旧密码
    const isMatch = await req.user.comparePassword(oldPassword);
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: '原密码错误'
      });
    }

    // 更新密码
    req.user.password = newPassword;
    await req.user.save();

    res.json({
      success: true,
      message: '密码修改成功'
    });
  } catch (error) {
    console.error('修改密码错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 登出
exports.logout = async (req, res) => {
  try {
    // 更新用户状态
    await User.findByIdAndUpdate(req.user._id, {
      status: 'offline',
      lastSeen: new Date()
    });

    res.json({
      success: true,
      message: '登出成功'
    });
  } catch (error) {
    console.error('登出错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};
