import 'package:flutter/material.dart';
import '../models/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(post.body, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
