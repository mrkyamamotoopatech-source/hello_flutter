import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/news_page_view_model.dart';
import 'news_page_body.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsPageViewModel()..loadInitial(),
      child: const NewsPageBody(),
    );
  }
}
