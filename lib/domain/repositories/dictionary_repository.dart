import 'package:word_mate/data/models/dictionary_entry_model.dart';

abstract class DictionaryRepository {
  Future<List<DictionaryEntryModel>> fetchWordDetails(String word);
}
