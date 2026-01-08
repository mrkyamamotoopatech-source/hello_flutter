import 'package:flutter/material.dart';
import '../usecase/settings_use_case.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsUseCase _useCase;

  bool _loading = true;
  bool get loading => _loading;

  bool _debugNetwork = false;
  bool get debugNetwork => _debugNetwork;

  int _pageSize = 10;
  int get pageSize => _pageSize;

  SettingsViewModel(this._useCase) {
    _load();
  }

  Future<void> _load() async {
    _debugNetwork = _useCase.getDebugNetwork();
    _pageSize = _useCase.getPageSize();
    _loading = false;
    notifyListeners();
  }

  Future<void> setDebugNetwork(bool value) async {
    _debugNetwork = value;
    notifyListeners();              // 先にUIを更新
    await _useCase.setDebugNetwork(value);
  }

  Future<void> setPageSize(int value) async {
    _pageSize = value;
    notifyListeners();
    await _useCase.setPageSize(value);
  }
}
