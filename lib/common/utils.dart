import 'package:word_mate/l10n/app_localizations.dart';

class AppUtils {
  /// Localize word type (noun, verb, adj, adv, other)
  static String getLocalizedWordType(String? type, AppLocalizations l10n) {
    if (type == null || type.trim().isEmpty) return '';
    final lower = type.trim().toLowerCase();
    switch (lower) {
      case 'noun':
        return l10n.typeNoun;
      case 'verb':
        return l10n.typeVerb;
      case 'adj':
      case 'adjective':
        return l10n.typeAdj;
      case 'adv':
      case 'adverb':
        return l10n.typeAdv;
      case 'other':
        return l10n.typeOther;
      default:
        return type;
    }
  }

  /// Localize default topic name (topic_id == -1 or 'khác' / 'other')
  static String getLocalizedTopicName({
    required int? topicId,
    required String? rawName,
    required AppLocalizations l10n,
  }) {
    if (topicId == -1 ||
        rawName?.trim().toLowerCase() == 'khác' ||
        rawName?.trim().toLowerCase() == 'other') {
      return l10n.otherTopic;
    }
    return rawName ?? '';
  }
}
