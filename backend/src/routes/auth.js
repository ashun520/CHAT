const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { authMiddleware } = require('../middleware/auth');
const { registerRules, loginRules, changePasswordRules } = require('../middleware/validators');

// 公开路由
router.post('/register', registerRules, authController.register);
router.post('/login', loginRules, authController.login);

// 需要认证的路由
router.use(authMiddleware);
router.get('/me', authController.getUserInfo);
router.put('/me', authController.updateUserInfo);
router.put('/password', changePasswordRules, authController.changePassword);
router.post('/logout', authController.logout);

module.exports = router;
