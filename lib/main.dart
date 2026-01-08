import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/news/data/post_repository.dart';
import 'features/news/data/settings_repository.dart';
import 'features/news/ui/news_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 初期化
  final settingsRepo = await SettingsRepository.create();
  final postRepo = PostRepository(settingsRepo);

  runApp(MyApp(
    settingsRepository: settingsRepo,
    postRepository: postRepo,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsRepository settingsRepository;
  final PostRepository postRepository;

  const MyApp({
    super.key,
    required this.settingsRepository,
    required this.postRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(value: settingsRepository),
        Provider<PostRepository>.value(value: postRepository),
      ],
      child: MaterialApp(
        home: const NewsPage(),
      ),
    );
  }
}
