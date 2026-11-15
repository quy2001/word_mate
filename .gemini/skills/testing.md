# Testing Patterns & Conventions

## Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7    # blocTest helper cho BLoC
  mocktail: ^1.0.4      # Mock library (no codegen)
```

## Cấu trúc test (mirror cấu trúc lib/)
```
test/
├── data/
│   └── repositories/
│       └── app_settings_repository_impl_test.dart
├── domain/
│   └── usecases/
│       ├── save_daily_goal_usecase_test.dart
│       └── save_user_profile_usecase_test.dart
├── presentation/
│   ├── views/
│   │   ├── register/register_bloc_test.dart
│   │   ├── daily_goal/daily_goal_bloc_test.dart
│   │   └── home/home_bloc_test.dart
│   └── widgets/
│       └── bottom_nav/bottom_nav_bloc_test.dart
└── widget_test.dart  # placeholder
```

## Chạy test
```bash
flutter test                          # tất cả
flutter test --reporter expanded      # chi tiết từng test
flutter test test/domain/             # chỉ domain layer
flutter test --coverage               # với coverage report
```

## Mock Pattern (mocktail)
```dart
import 'package:mocktail/mocktail.dart';

// 1. Tạo mock class
class MockMyRepo extends Mock implements MyRepository {}

// 2. Register fallback cho custom types (trong setUpAll)
setUpAll(() {
  registerFallbackValue(MyParams(data: ''));
});

// 3. Setup mock behavior
when(() => mockRepo.save(any())).thenAnswer((_) async {});
when(() => mockRepo.save(any())).thenThrow(Exception('error'));

// 4. Verify calls
verify(() => mockRepo.save(any())).called(1);
verifyNever(() => mockRepo.delete(any()));
```

## BLoC Test Pattern
```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<MyBloc, MyState>(
  'description',
  build: () {
    // Setup mocks
    when(() => mockUseCase(any())).thenAnswer((_) async => DataSuccess(null));
    return MyBloc(mockUseCase);
  },
  seed: () => MyState(data: 'initial'),  // optional: set initial state
  act: (bloc) => bloc.add(MyEvent()),
  expect: () => [
    MyState(status: MyStatus.loading),
    MyState(status: MyStatus.loaded, data: 'result'),
  ],
  verify: (_) {
    verify(() => mockUseCase(any())).called(1);
  },
);
```

## Test Coverage theo layer

### Repository Tests
- Verify DAO gọi đúng key/params
- Test int↔string conversion
- Test null handling

### UseCase Tests  
- Test DataSuccess path
- Test DioException → DataFail
- Test generic Exception → DataFail (wrapped)
- Test call order (nếu gọi nhiều repo methods)

### BLoC Tests
- Test initial state
- Test mỗi event riêng biệt
- Test boundary conditions (min/max values)
- Test submit flow: [submitting → success|failure]
- Test guard clauses (isValid, etc.)
- Test sequential events

## Quy ước
1. File test đặt tên `<class>_test.dart`
2. Group theo class/feature
3. Mô tả test phải rõ ràng, mô tả behavior
4. Dùng `setUp` cho mock, `setUpAll` cho fallback values
5. BLoC luôn test: initial state + mỗi event + error path
6. **KHÔNG** test widget render trong unit test - tách riêng
