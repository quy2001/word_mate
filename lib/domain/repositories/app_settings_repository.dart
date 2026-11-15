abstract class AppSettingsRepository {
  Future<void> saveAvatar(String avatarPath);
  Future<void> saveNickname(String nickname);
  Future<void> saveDailyGoal(int goal);
  Future<String?> getAvatar();
  Future<String?> getNickname();
  Future<int?> getDailyGoal();
  Future<void> saveLocale(String languageCode);
  Future<String?> getLocale();
}
