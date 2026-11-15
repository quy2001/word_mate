import 'package:word_mate/common/constants.dart';
import 'package:word_mate/data/data_sources/local/app_settings_dao.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsDao _dao;

  AppSettingsRepositoryImpl(this._dao);

  @override
  Future<void> saveAvatar(String avatarPath) {
    return _dao.saveSetting(Constants.keyAvatar, avatarPath);
  }

  @override
  Future<void> saveNickname(String nickname) {
    return _dao.saveSetting(Constants.keyNickname, nickname);
  }

  @override
  Future<void> saveDailyGoal(int goal) {
    return _dao.saveSetting(Constants.keyDailyGoal, goal.toString());
  }

  @override
  Future<String?> getAvatar() {
    return _dao.getSetting(Constants.keyAvatar);
  }

  @override
  Future<String?> getNickname() {
    return _dao.getSetting(Constants.keyNickname);
  }

  @override
  Future<int?> getDailyGoal() async {
    final value = await _dao.getSetting(Constants.keyDailyGoal);
    return value != null ? int.tryParse(value) : null;
  }

  @override
  Future<void> saveLocale(String languageCode) {
    return _dao.saveSetting(Constants.keyLocale, languageCode);
  }

  @override
  Future<String?> getLocale() {
    return _dao.getSetting(Constants.keyLocale);
  }
}
