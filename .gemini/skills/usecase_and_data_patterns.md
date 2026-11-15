# UseCase & Data Layer Patterns

## UseCase Base Class (`lib/core/usecase.dart`)
```dart
abstract class UseCase<T, P> {
  Future<DataState<T>> call(P params);
}
```

## DataState Pattern (`lib/core/data_state.dart`)
```dart
abstract class DataState<T> {
  final T? data;
  final DioException? exception;
}

class DataSuccess<T> extends DataState<T>  // → data != null, exception == null
class DataFail<T> extends DataState<T>     // → data == null, exception != null
```

## UseCase với Params
```dart
class Save<Entity>UseCase implements UseCase<void, Save<Entity>Params> {
  final <Entity>Repository _repository;

  Save<Entity>UseCase(this._repository);

  @override
  Future<DataState<void>> call(Save<Entity>Params params) async {
    try {
      await _repository.save(params.data);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFail(e);
    } catch (e) {
      return DataFail(DioException(requestOptions: RequestOptions(path: ''), error: e));
    }
  }
}

class Save<Entity>Params {
  final <Type> data;
  Save<Entity>Params({required this.data});
}
```

## UseCase không Params (query data)
```dart
class Get<Entity>UseCase {
  final <Entity>Repository _repo;
  Get<Entity>UseCase(this._repo);

  Future<<ResultType>> call() async {
    // Gom nhiều Future.wait nếu cần
    final results = await Future.wait([...]);
    return <ResultType>(...);
  }
}
```
> **Lưu ý**: `GetHomeDataUseCase` KHÔNG implement `UseCase<T,P>` vì không dùng DataState.

## Repository Interface Pattern
```dart
// domain/repositories/
abstract class <Entity>Repository {
  Future<void> save<Entity>(<Type> data);
  Future<<Type>?> get<Entity>();
  Future<List<<Type>>> getAll();
}
```

## Repository Implementation Pattern
```dart
// data/repositories/
class <Entity>RepositoryImpl implements <Entity>Repository {
  final <Entity>Dao _dao;
  <Entity>RepositoryImpl(this._dao);

  @override
  Future<void> save<Entity>(<Type> data) => _dao.save(data);
}
```

## DAO Pattern (Data Access Object)
```dart
// data/data_sources/local/
class <Entity>Dao {
  final AppDatabase _appDatabase;
  <Entity>Dao(this._appDatabase);

  Future<void> insert(<Type> data) async {
    final db = await _appDatabase.database;
    await db.insert('TableName', data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await _appDatabase.database;
    return db.query('TableName', orderBy: 'created_at DESC');
  }
}
```

## Quy ước
- **Tất cả DAO** nhận `AppDatabase` qua constructor
- **DAO trả về** `Map<String, dynamic>` hoặc primitive types
- **Repository** đóng vai trò adapter giữa DAO ↔ Domain
- **UseCase** chứa business logic, orchestrate nhiều repository nếu cần
- **Error handling**: wrap non-DioException thành DioException cho DataFail
