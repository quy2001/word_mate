import 'package:word_mate/data/data_sources/remote/dictionary_api_service.dart';
import 'package:word_mate/data/models/dictionary_entry_model.dart';
import 'package:word_mate/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryApiService _apiService;

  DictionaryRepositoryImpl(this._apiService);

  @override
  Future<List<DictionaryEntryModel>> fetchWordDetails(String word) async {
    return await _apiService.fetchWordDetails(word);
  }
}
