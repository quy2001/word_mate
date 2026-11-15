import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your English vocab companion ✨'**
  String get registerSubtitle;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose your avatar'**
  String get chooseAvatar;

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Your nickname...'**
  String get nicknameHint;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get letsGo;

  /// No description provided for @setDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set your daily goal 🎯'**
  String get setDailyGoal;

  /// No description provided for @howManyWords.
  ///
  /// In en, this message translates to:
  /// **'How many words will you learn each day?'**
  String get howManyWords;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting...'**
  String get starting;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @wordsPerDay.
  ///
  /// In en, this message translates to:
  /// **'words per day'**
  String get wordsPerDay;

  /// No description provided for @wordsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'📅 That\'s ~{count} words a month!'**
  String wordsPerMonth(int count);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @todaysGoal.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Goal'**
  String get todaysGoal;

  /// No description provided for @goalCrushed.
  ///
  /// In en, this message translates to:
  /// **'You\'ve crushed your goal! 🎉'**
  String get goalCrushed;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there! {remaining} more\nwords to reach your daily\npeak.'**
  String almostThere(int remaining);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'DAY STREAK'**
  String get dayStreak;

  /// No description provided for @wordsSaved.
  ///
  /// In en, this message translates to:
  /// **'WORDS SAVED'**
  String get wordsSaved;

  /// No description provided for @dueForReview.
  ///
  /// In en, this message translates to:
  /// **'Due for Review'**
  String get dueForReview;

  /// No description provided for @wordsPending.
  ///
  /// In en, this message translates to:
  /// **'{count} words pending'**
  String wordsPending(int count);

  /// No description provided for @noWordsDue.
  ///
  /// In en, this message translates to:
  /// **'No words due! 🎉'**
  String get noWordsDue;

  /// No description provided for @startReview.
  ///
  /// In en, this message translates to:
  /// **'Start Review'**
  String get startReview;

  /// No description provided for @popularTopics.
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get popularTopics;

  /// No description provided for @searchTopics.
  ///
  /// In en, this message translates to:
  /// **'Search topics...'**
  String get searchTopics;

  /// No description provided for @failedToLoadTopics.
  ///
  /// In en, this message translates to:
  /// **'Failed to load topics'**
  String get failedToLoadTopics;

  /// No description provided for @deleteTopic.
  ///
  /// In en, this message translates to:
  /// **'Delete Topic'**
  String get deleteTopic;

  /// No description provided for @deleteTopicConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{topicName}\"? The words in this topic will not be deleted.'**
  String deleteTopicConfirm(String topicName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @newTopic.
  ///
  /// In en, this message translates to:
  /// **'New Topic'**
  String get newTopic;

  /// No description provided for @topicName.
  ///
  /// In en, this message translates to:
  /// **'Topic Name'**
  String get topicName;

  /// No description provided for @topicNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Academic, Travel...'**
  String get topicNameHint;

  /// No description provided for @chooseThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Choose a theme color'**
  String get chooseThemeColor;

  /// No description provided for @createTopic.
  ///
  /// In en, this message translates to:
  /// **'Create Topic'**
  String get createTopic;

  /// No description provided for @wordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordsCount(int count);

  /// No description provided for @searchWord.
  ///
  /// In en, this message translates to:
  /// **'Search word...'**
  String get searchWord;

  /// No description provided for @failedToLoadVocab.
  ///
  /// In en, this message translates to:
  /// **'Failed to load vocabulary list.'**
  String get failedToLoadVocab;

  /// No description provided for @noWordsFound.
  ///
  /// In en, this message translates to:
  /// **'No words found.'**
  String get noWordsFound;

  /// No description provided for @cannotPlayAudio.
  ///
  /// In en, this message translates to:
  /// **'Cannot play audio! 🔊'**
  String get cannotPlayAudio;

  /// No description provided for @noAudioData.
  ///
  /// In en, this message translates to:
  /// **'This word has no audio data! 🔊'**
  String get noAudioData;

  /// No description provided for @timeSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds'**
  String timeSeconds(int count);

  /// No description provided for @timeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String timeMinutes(int count);

  /// No description provided for @timeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} hours'**
  String timeHours(int count);

  /// No description provided for @timeDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String timeDays(int count);

  /// No description provided for @timeMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} months'**
  String timeMonths(int count);

  /// No description provided for @timeYears.
  ///
  /// In en, this message translates to:
  /// **'{count} years'**
  String timeYears(int count);

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'You have completed!'**
  String get completed;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @failedToLoadCards.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cards.'**
  String get failedToLoadCards;

  /// No description provided for @newWord.
  ///
  /// In en, this message translates to:
  /// **'New Word ✨'**
  String get newWord;

  /// No description provided for @enterWord.
  ///
  /// In en, this message translates to:
  /// **'Enter word...'**
  String get enterWord;

  /// No description provided for @meaningHint.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese meaning...'**
  String get meaningHint;

  /// No description provided for @wordAdded.
  ///
  /// In en, this message translates to:
  /// **'Word added successfully! ✨'**
  String get wordAdded;

  /// No description provided for @failedToAddWord.
  ///
  /// In en, this message translates to:
  /// **'Failed to add word. Please try again.'**
  String get failedToAddWord;

  /// No description provided for @wordType.
  ///
  /// In en, this message translates to:
  /// **'Word Type'**
  String get wordType;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @topicNameHint2.
  ///
  /// In en, this message translates to:
  /// **'Topic name...'**
  String get topicNameHint2;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLabel;

  /// No description provided for @addToWordy.
  ///
  /// In en, this message translates to:
  /// **'Add to WORDY ✨'**
  String get addToWordy;

  /// No description provided for @addTopic.
  ///
  /// In en, this message translates to:
  /// **'Add Topic'**
  String get addTopic;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @statsScreen.
  ///
  /// In en, this message translates to:
  /// **'Stats Screen'**
  String get statsScreen;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @wordDetail.
  ///
  /// In en, this message translates to:
  /// **'Word Detail'**
  String get wordDetail;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'EXAMPLE'**
  String get example;

  /// No description provided for @reviewStreak.
  ///
  /// In en, this message translates to:
  /// **'REVIEW STREAK'**
  String get reviewStreak;

  /// No description provided for @memoryLevel.
  ///
  /// In en, this message translates to:
  /// **'MEMORY LEVEL'**
  String get memoryLevel;

  /// No description provided for @nextInDays.
  ///
  /// In en, this message translates to:
  /// **'Next: in {days} days'**
  String nextInDays(int days);

  /// No description provided for @nextToday.
  ///
  /// In en, this message translates to:
  /// **'Next: Today'**
  String get nextToday;

  /// No description provided for @nextTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Next: Tomorrow'**
  String get nextTomorrow;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteWordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this word?'**
  String get deleteWordConfirm;

  /// No description provided for @wordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Word deleted successfully'**
  String get wordDeleted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
