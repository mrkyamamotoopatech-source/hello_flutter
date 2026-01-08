import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/post_repository.dart';
import '../data/settings_repository.dart';
import '../view_model/news_page_view_model.dart';
import 'news_page_body.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsRepository>(
      future: SettingsRepository.create(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return ChangeNotifierProvider(
          create: (_) => NewsPageViewModel(context.read<PostRepository>(),)..loadInitial(),
          child: const NewsPageBody(),
        );
      },
    );
  }
}
