import 'package:flutter/material.dart';
import '../data/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repo;

  bool _loading = true;
  bool get loading => _loading;

  bool _debugNetwork = false;
  bool get debugNetwork => _debugNetwork;

  int _pageSize = 10;
  int get pageSize => _pageSize;

  SettingsViewModel(this._repo) {
    _load();
  }

  Future<void> _load() async {
    _debugNetwork = _repo.getDebugNetwork();
    _pageSize = _repo.getPageSize();
    _loading = false;
    notifyListeners();
  }

  Future<void> setDebugNetwork(bool value) async {
    _debugNetwork = value;
    notifyListeners();              // 先にUIを更新
    await _repo.setDebugNetwork(value);
  }

  Future<void> setPageSize(int value) async {
    _pageSize = value;
    notifyListeners();
    await _repo.setPageSize(value);
  }
}
