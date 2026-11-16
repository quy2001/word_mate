// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get registerSubtitle => 'Your English vocab companion ✨';

  @override
  String get chooseAvatar => 'Choose your avatar';

  @override
  String get whatShouldWeCallYou => 'What should we call you?';

  @override
  String get nicknameHint => 'Your nickname...';

  @override
  String get saving => 'Saving...';

  @override
  String get letsGo => 'Let\'s go';

  @override
  String get setDailyGoal => 'Set your daily goal 🎯';

  @override
  String get howManyWords => 'How many words will you learn each day?';

  @override
  String get starting => 'Starting...';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get wordsPerDay => 'words per day';

  @override
  String wordsPerMonth(int count) {
    return '📅 That\'s ~$count words a month!';
  }

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get todaysGoal => 'Today\'s Goal';

  @override
  String get goalCrushed => 'You\'ve crushed your goal! 🎉';

  @override
  String almostThere(int remaining) {
    return 'Almost there! $remaining more\nwords to reach your daily\npeak.';
  }

  @override
  String get dayStreak => 'DAY STREAK';

  @override
  String get wordsSaved => 'WORDS SAVED';

  @override
  String get dueForReview => 'Due for Review';

  @override
  String wordsPending(int count) {
    return '$count words pending';
  }

  @override
  String get noWordsDue => 'No words due! 🎉';

  @override
  String get startReview => 'Start Review';

  @override
  String get popularTopics => 'Popular Topics';

  @override
  String get searchTopics => 'Search topics...';

  @override
  String get failedToLoadTopics => 'Failed to load topics';

  @override
  String get deleteTopic => 'Delete Topic';

  @override
  String deleteTopicConfirm(String topicName) {
    return 'Are you sure you want to delete \"$topicName\"? The words in this topic will not be deleted.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get newTopic => 'New Topic';

  @override
  String get topicName => 'Topic Name';

  @override
  String get topicNameHint => 'e.g., Academic, Travel...';

  @override
  String get chooseThemeColor => 'Choose a theme color';

  @override
  String get createTopic => 'Create Topic';

  @override
  String wordsCount(int count) {
    return '$count words';
  }

  @override
  String get searchWord => 'Search word...';

  @override
  String get failedToLoadVocab => 'Failed to load vocabulary list.';

  @override
  String get noWordsFound => 'No words found.';

  @override
  String get cannotPlayAudio => 'Cannot play audio! 🔊';

  @override
  String get noAudioData => 'This word has no audio data! 🔊';

  @override
  String timeSeconds(int count) {
    return '$count seconds';
  }

  @override
  String timeMinutes(int count) {
    return '$count minutes';
  }

  @override
  String timeHours(int count) {
    return '$count hours';
  }

  @override
  String timeDays(int count) {
    return '$count days';
  }

  @override
  String timeMonths(int count) {
    return '$count months';
  }

  @override
  String timeYears(int count) {
    return '$count years';
  }

  @override
  String get learning => 'Learning';

  @override
  String get mastered => 'Mastered';

  @override
  String get completed => 'You have completed!';

  @override
  String get goBack => 'Go Back';

  @override
  String get failedToLoadCards => 'Failed to load cards.';

  @override
  String get newWord => 'New Word ✨';

  @override
  String get enterWord => 'Enter word...';

  @override
  String get meaningHint => 'Enter meaning...';

  @override
  String get wordAdded => 'Word added successfully! ✨';

  @override
  String get failedToAddWord => 'Failed to add word. Please try again.';

  @override
  String get wordType => 'Word Type';

  @override
  String get topics => 'Topics';

  @override
  String get topicNameHint2 => 'Topic name...';

  @override
  String get add => 'Add';

  @override
  String get newLabel => 'New';

  @override
  String get addToWordy => 'Add to WORDY ✨';

  @override
  String get addTopic => 'Add Topic';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get appLanguage => 'App Language';

  @override
  String get chooseLanguage => 'Choose your preferred language';

  @override
  String get statsScreen => 'Stats Screen';

  @override
  String get home => 'Home';

  @override
  String get navStats => 'Stats';

  @override
  String get wordDetail => 'Word Detail';

  @override
  String get example => 'EXAMPLE';

  @override
  String get reviewStreak => 'REVIEW STREAK';

  @override
  String get memoryLevel => 'MEMORY LEVEL';

  @override
  String nextInDays(int days) {
    return 'Next: in $days days';
  }

  @override
  String get nextToday => 'Next: Today';

  @override
  String get nextTomorrow => 'Next: Tomorrow';

  @override
  String get edit => 'Edit';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteWordConfirm => 'Are you sure you want to delete this word?';

  @override
  String get wordDeleted => 'Word deleted successfully';

  @override
  String get otherTopic => 'Other';

  @override
  String get profile => 'Profile';

  @override
  String get wordMateLearner => 'Word Mate Learner';

  @override
  String get targetWordsPerDay => 'Target words/day';

  @override
  String get noExample => 'No example';

  @override
  String get weeklyActivity => 'Weekly Activity';

  @override
  String reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get accuracy => 'Accuracy';

  @override
  String get dueToday => 'Due Today';

  @override
  String get daysInARow => 'days in a row';

  @override
  String get totalVocabulary => 'total vocabulary';

  @override
  String get retentionSolid => 'retention solid';

  @override
  String get inProgress => 'in progress';

  @override
  String get typeNoun => 'Noun';

  @override
  String get typeVerb => 'Verb';

  @override
  String get typeAdj => 'Adj';

  @override
  String get typeAdv => 'Adv';

  @override
  String get typeOther => 'Other';
}
