import 'package:word_mate/domain/repositories/home_repository.dart';

class GetStatsUseCase {
  final HomeRepository _homeRepository;

  GetStatsUseCase(this._homeRepository);

  Future<Map<String, dynamic>> call() => _homeRepository.getStatistics();
}
