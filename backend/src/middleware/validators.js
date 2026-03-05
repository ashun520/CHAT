const { body, validationResult } = require('express-validator');

// 注册验证规则
exports.registerRules = [
  body('username')
    .trim()
    .isLength({ min: 3, max: 30 })
    .withMessage('用户名长度必须在 3-30 个字符之间')
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage('用户名只能包含字母、数字和下划线'),
  
  body('email')
    .trim()
    .isEmail()
    .withMessage('请输入有效的邮箱地址')
    .normalizeEmail(),
  
  body('phone')
    .trim()
    .isMobilePhone('zh-CN')
    .withMessage('请输入有效的手机号码'),
  
  body('password')
    .isLength({ min: 6 })
    .withMessage('密码长度至少为 6 位')
    .matches(/\d/)
    .withMessage('密码必须包含数字')
];

// 登录验证规则
exports.loginRules = [
  body('account')
    .trim()
    .notEmpty()
    .withMessage('请输入账号（邮箱/手机号/用户名）'),
  
  body('password')
    .notEmpty()
    .withMessage('请输入密码')
];

// 修改密码验证规则
exports.changePasswordRules = [
  body('oldPassword')
    .notEmpty()
    .withMessage('请输入原密码'),
  
  body('newPassword')
    .isLength({ min: 6 })
    .withMessage('新密码长度至少为 6 位')
    .matches(/\d/)
    .withMessage('密码必须包含数字')
];
