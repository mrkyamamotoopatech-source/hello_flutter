import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../usecase/fetch_posts_use_case.dart';
import '../view_model/news_page_view_model.dart';
import 'news_page_body.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsPageViewModel(
        context.read<FetchPostsUseCase>(),
      )..loadInitial(),
      child: const NewsPageBody(),
    );
  }
}
