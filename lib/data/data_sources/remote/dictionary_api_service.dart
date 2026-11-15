import 'package:dio/dio.dart';
import 'package:word_mate/data/models/dictionary_entry_model.dart';

class DictionaryApiService {
  final Dio _dio;
  
  DictionaryApiService(this._dio);

  Future<List<DictionaryEntryModel>> fetchWordDetails(String word) async {
    final response = await _dio.get('https://api.dictionaryapi.dev/api/v2/entries/en/$word');
    if (response.statusCode == 200) {
      final data = response.data as List<dynamic>;
      return data.map((e) => DictionaryEntryModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
      );
    }
  }
}
