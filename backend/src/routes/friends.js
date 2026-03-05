const express = require('express');
const router = express.Router();
const friendController = require('../controllers/friendController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/friends', friendController.getFriends);
router.get('/search', friendController.searchUsers);
router.post('/requests/send', friendController.sendFriendRequest);
router.get('/requests', friendController.getFriendRequests);
router.post('/requests/handle', friendController.handleFriendRequest);
router.delete('/friends/:friendId', friendController.removeFriend);
router.post('/blacklist', friendController.addToBlackList);
router.delete('/blacklist/:userId', friendController.removeFromBlackList);

module.exports = router;
