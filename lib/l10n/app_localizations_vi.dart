// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get registerSubtitle => 'Người bạn đồng hành học từ vựng ✨';

  @override
  String get chooseAvatar => 'Chọn ảnh đại diện';

  @override
  String get whatShouldWeCallYou => 'Bạn muốn được gọi là gì?';

  @override
  String get nicknameHint => 'Biệt danh của bạn...';

  @override
  String get saving => 'Đang lưu...';

  @override
  String get letsGo => 'Bắt đầu nào';

  @override
  String get setDailyGoal => 'Đặt mục tiêu hàng ngày 🎯';

  @override
  String get howManyWords => 'Bạn sẽ học bao nhiêu từ mỗi ngày?';

  @override
  String get starting => 'Đang bắt đầu...';

  @override
  String get startLearning => 'Bắt đầu học';

  @override
  String get wordsPerDay => 'từ mỗi ngày';

  @override
  String wordsPerMonth(int count) {
    return '📅 Tương đương ~$count từ mỗi tháng!';
  }

  @override
  String get goodMorning => 'Chào buổi sáng';

  @override
  String get goodAfternoon => 'Chào buổi chiều';

  @override
  String get goodEvening => 'Chào buổi tối';

  @override
  String get todaysGoal => 'Mục tiêu hôm nay';

  @override
  String get goalCrushed => 'Bạn đã hoàn thành mục tiêu! 🎉';

  @override
  String almostThere(int remaining) {
    return 'Sắp xong rồi! Còn $remaining từ\nnữa để đạt mục tiêu\nhàng ngày.';
  }

  @override
  String get dayStreak => 'CHUỖI NGÀY';

  @override
  String get wordsSaved => 'TỪ ĐÃ LƯU';

  @override
  String get dueForReview => 'Cần ôn tập';

  @override
  String wordsPending(int count) {
    return '$count từ đang chờ';
  }

  @override
  String get noWordsDue => 'Không có từ nào cần ôn! 🎉';

  @override
  String get startReview => 'Bắt đầu ôn tập';

  @override
  String get popularTopics => 'Chủ đề phổ biến';

  @override
  String get searchTopics => 'Tìm chủ đề...';

  @override
  String get failedToLoadTopics => 'Không thể tải danh sách chủ đề';

  @override
  String get deleteTopic => 'Xoá chủ đề';

  @override
  String deleteTopicConfirm(String topicName) {
    return 'Bạn có chắc muốn xoá \"$topicName\"? Các từ trong chủ đề này sẽ không bị xoá.';
  }

  @override
  String get cancel => 'Huỷ';

  @override
  String get delete => 'Xoá';

  @override
  String get newTopic => 'Chủ đề mới';

  @override
  String get topicName => 'Tên chủ đề';

  @override
  String get topicNameHint => 'VD: Học thuật, Du lịch...';

  @override
  String get chooseThemeColor => 'Chọn màu chủ đề';

  @override
  String get createTopic => 'Tạo chủ đề';

  @override
  String wordsCount(int count) {
    return '$count từ';
  }

  @override
  String get searchWord => 'Tìm từ...';

  @override
  String get failedToLoadVocab => 'Không thể tải danh sách từ vựng.';

  @override
  String get noWordsFound => 'Không tìm thấy từ nào.';

  @override
  String get cannotPlayAudio => 'Không thể phát âm thanh! 🔊';

  @override
  String get noAudioData => 'Từ này chưa có dữ liệu âm thanh! 🔊';

  @override
  String timeSeconds(int count) {
    return '$count giây';
  }

  @override
  String timeMinutes(int count) {
    return '$count phút';
  }

  @override
  String timeHours(int count) {
    return '$count giờ';
  }

  @override
  String timeDays(int count) {
    return '$count ngày';
  }

  @override
  String timeMonths(int count) {
    return '$count tháng';
  }

  @override
  String timeYears(int count) {
    return '$count năm';
  }

  @override
  String get learning => 'Đang học';

  @override
  String get mastered => 'Đã biết';

  @override
  String get completed => 'Bạn đã hoàn thành!';

  @override
  String get goBack => 'Trở về';

  @override
  String get failedToLoadCards => 'Không thể tải thẻ.';

  @override
  String get newWord => 'Từ mới ✨';

  @override
  String get enterWord => 'Nhập từ...';

  @override
  String get meaningHint => 'Nghĩa tiếng Việt...';

  @override
  String get wordAdded => 'Đã thêm từ thành công! ✨';

  @override
  String get failedToAddWord => 'Không thể thêm từ. Vui lòng thử lại.';

  @override
  String get wordType => 'Loại từ';

  @override
  String get topics => 'Chủ đề';

  @override
  String get topicNameHint2 => 'Tên chủ đề...';

  @override
  String get add => 'Thêm';

  @override
  String get newLabel => 'Mới';

  @override
  String get addToWordy => 'Thêm vào WORDY ✨';

  @override
  String get addTopic => 'Thêm chủ đề';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get appLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ bạn muốn';

  @override
  String get statsScreen => 'Màn hình thống kê';

  @override
  String get home => 'Trang chủ';

  @override
  String get navStats => 'Thống kê';

  @override
  String get wordDetail => 'Chi tiết từ';

  @override
  String get example => 'VÍ DỤ';

  @override
  String get reviewStreak => 'CHUỖI ÔN TẬP';

  @override
  String get memoryLevel => 'MỨC ĐỘ GHI NHỚ';

  @override
  String nextInDays(int days) {
    return 'Tiếp theo: $days ngày nữa';
  }

  @override
  String get nextToday => 'Tiếp theo: Hôm nay';

  @override
  String get nextTomorrow => 'Tiếp theo: Ngày mai';

  @override
  String get edit => 'Sửa';

  @override
  String get confirmDelete => 'Xác nhận xoá';

  @override
  String get deleteWordConfirm => 'Bạn có chắc muốn xoá từ này không?';

  @override
  String get wordDeleted => 'Đã xoá từ thành công';
}
