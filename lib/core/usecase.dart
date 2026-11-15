import 'package:word_mate/core/index.dart';

abstract class UseCase<T, P> {
  Future<DataState<T>> call(P params);
}
