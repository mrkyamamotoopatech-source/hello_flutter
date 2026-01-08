// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hello_flutter/features/news/models/post.dart';
import 'package:hello_flutter/features/news/usecase/fetch_posts_use_case.dart';
import 'package:hello_flutter/features/news/usecase/settings_use_case.dart';
import 'package:hello_flutter/main.dart';

class FakeFetchPostsUseCase implements FetchPostsUseCase {
  FakeFetchPostsUseCase(this._handler);

  final Future<List<Post>> Function(int page) _handler;

  @override
  Future<List<Post>> call(int page) => _handler(page);
}

class FakeSettingsUseCase implements SettingsUseCase {
  bool _debugNetwork = false;
  int _pageSize = 10;

  @override
  bool getDebugNetwork() => _debugNetwork;

  @override
  int getPageSize() => _pageSize;

  @override
  Future<void> setDebugNetwork(bool value) async {
    _debugNetwork = value;
  }

  @override
  Future<void> setPageSize(int value) async {
    _pageSize = value;
  }
}

void main() {
  testWidgets('Shows empty state when no posts are returned',
      (WidgetTester tester) async {
    final settingsUseCase = FakeSettingsUseCase();
    final fetchPostsUseCase =
        FakeFetchPostsUseCase((_) async => const <Post>[]);

    await tester.pumpWidget(
      MyApp(
        settingsUseCase: settingsUseCase,
        fetchPostsUseCase: fetchPostsUseCase,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('データがありません'), findsOneWidget);
  });
}
