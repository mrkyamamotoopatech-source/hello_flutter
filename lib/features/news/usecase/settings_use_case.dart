import '../data/settings_repository.dart';

class SettingsUseCase {
  final SettingsRepository _repo;

  SettingsUseCase(this._repo);

  bool getDebugNetwork() => _repo.getDebugNetwork();

  int getPageSize() => _repo.getPageSize();

  Future<void> setDebugNetwork(bool value) => _repo.setDebugNetwork(value);

  Future<void> setPageSize(int value) => _repo.setPageSize(value);
}
