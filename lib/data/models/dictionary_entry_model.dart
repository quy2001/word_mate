class DictionaryEntryModel {
  final String word;
  final List<PhoneticModel> phonetics;
  final List<MeaningModel> meanings;

  DictionaryEntryModel({
    required this.word,
    required this.phonetics,
    required this.meanings,
  });

  factory DictionaryEntryModel.fromJson(Map<String, dynamic> json) {
    return DictionaryEntryModel(
      word: json['word'] ?? '',
      phonetics: (json['phonetics'] as List<dynamic>?)
              ?.map((e) => PhoneticModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((e) => MeaningModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PhoneticModel {
  final String text;
  final String audio;
  final String licenseName;

  PhoneticModel({
    required this.text,
    required this.audio,
    required this.licenseName,
  });

  factory PhoneticModel.fromJson(Map<String, dynamic> json) {
    String license = '';
    if (json['license'] != null && json['license'] is Map) {
      license = json['license']['name'] ?? '';
    }
    return PhoneticModel(
      text: json['text'] ?? '',
      audio: json['audio'] ?? '',
      licenseName: license,
    );
  }
}

class MeaningModel {
  final String partOfSpeech;
  final List<DefinitionModel> definitions;

  MeaningModel({
    required this.partOfSpeech,
    required this.definitions,
  });

  factory MeaningModel.fromJson(Map<String, dynamic> json) {
    return MeaningModel(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => DefinitionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DefinitionModel {
  final String definition;
  final String example;

  DefinitionModel({
    required this.definition,
    required this.example,
  });

  factory DefinitionModel.fromJson(Map<String, dynamic> json) {
    return DefinitionModel(
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
    );
  }
}
