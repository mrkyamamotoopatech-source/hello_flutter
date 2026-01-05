import 'package:flutter/material.dart';
import '../data/post_api.dart';
import '../models/post.dart';

class NewsPageViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  int _page = 0;
  int get page => _page;

  Future<void> load(int page) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await PostApi.fetch(page);
      _posts = result;
      _page = page;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
