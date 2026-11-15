import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;

  const DataState({
    this.data,
    this.exception,
  });
}

class DataSuccess<T> extends DataState<T> {
  final T d;

  const DataSuccess(this.d)
      : super(
          data: d,
          exception: null,
        );
}

class DataFail<T> extends DataState<T> {
  final DioException e;

  const DataFail(this.e)
      : super(
          data: null,
          exception: e,
        );
}
