import 'package:flutter/material.dart';

class MomentScreen extends StatelessWidget {
  const MomentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('朋友圈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // TODO: 发布动态
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 头部 - 封面和个人信息
          Stack(
            children: [
              Container(
                height: 200,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Icon(
                    Icons.photo,
                    size: 60,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 1),
          // 动态列表
          _buildMomentItem(
            context,
            '张三',
            '今天天气真好！',
            '2 小时前',
            3,
            5,
          ),
          const Divider(height: 16),
          _buildMomentItem(
            context,
            '李四',
            '分享一首好听的歌',
            '5 小时前',
            1,
            2,
          ),
          const Divider(height: 16),
          // 加载更多
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMomentItem(
    BuildContext context,
    String username,
    String content,
    String time,
    int imageCount,
    int likeCount,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (imageCount > 0) ...[
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childCount: imageCount > 9 ? 9 : imageCount,
              children: List.generate(
                imageCount > 9 ? 9 : imageCount,
                (index) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey[500]),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '$likeCount',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '3',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
            ],
          ),
        ],
      ),
    );
  }
}
