import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/news/data/post_repository.dart';
import 'features/news/data/settings_repository.dart';
import 'features/news/ui/news_page.dart';
import 'features/news/usecase/fetch_posts_use_case.dart';
import 'features/news/usecase/settings_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 初期化
  final settingsRepo = await SettingsRepository.create();
  final postRepo = PostRepository(settingsRepo);
  final settingsUseCase = SettingsUseCase(settingsRepo);
  final fetchPostsUseCase = FetchPostsUseCase(postRepo);

  runApp(MyApp(
    settingsUseCase: settingsUseCase,
    fetchPostsUseCase: fetchPostsUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsUseCase settingsUseCase;
  final FetchPostsUseCase fetchPostsUseCase;

  const MyApp({
    super.key,
    required this.settingsUseCase,
    required this.fetchPostsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsUseCase>.value(value: settingsUseCase),
        Provider<FetchPostsUseCase>.value(value: fetchPostsUseCase),
      ],
      child: MaterialApp(
        home: const NewsPage(),
      ),
    );
  }
}
