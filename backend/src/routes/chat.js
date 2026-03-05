const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/conversations', chatController.getConversations);
router.get('/messages', chatController.getMessages);
router.post('/read', chatController.markAsRead);
router.delete('/messages/:messageId', chatController.deleteMessage);

module.exports = router;
