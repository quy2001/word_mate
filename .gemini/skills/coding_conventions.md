# Coding Style & Conventions

## Dart/Flutter
- Dart SDK: ^3.6.2
- Linter: flutter_lints ^5.0.0 (xem `analysis_options.yaml`)
- Generated code: `flutter_gen_runner` → `lib/gen/`

## Naming Conventions
| Loại | Convention | Ví dụ |
|------|-----------|-------|
| File | snake_case | `home_bloc.dart` |
| Class | PascalCase | `HomeBloc` |
| Variable | camelCase | `dailyGoal` |
| Constant | camelCase hoặc kPrefix | `keyNickname`, `kDesignWidth` |
| DB Table | PascalCase | `AppSettings`, `Cards` |
| DB Column | snake_case | `card_id`, `created_at` |
| Route path | kebab-case | `/daily-goal` |

## Import Order
1. `dart:*`
2. `package:flutter/*`
3. `package:<third_party>/*`
4. `package:word_mate/*`

## Code Generation
```bash
# Chạy build_runner
dart run build_runner build --delete-conflicting-outputs

# Chỉ flutter_gen
dart run flutter_gen_runner
```

## Error Handling Pattern
```dart
try {
  await repository.doSomething();
  return const DataSuccess(null);
} on DioException catch (e) {
  return DataFail(e);
} catch (e) {
  return DataFail(DioException(
    requestOptions: RequestOptions(path: ''),
    error: e,
  ));
}
```

## Barrel Exports
- `common/index.dart` → export tất cả common files
- `core/index.dart` → export data_state, usecase, bloc_observer
