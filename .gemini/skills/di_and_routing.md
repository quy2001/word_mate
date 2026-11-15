# Dependency Injection & Routing

## DI Container - GetIt (`lib/injector.dart`)

### Thứ tự đăng ký (QUAN TRỌNG)
```
1. Common (Dio, SecureStorage)
2. Database (AppDatabase)
3. DAOs (AppSettingsDao, HomeDao)
4. Repositories (AppSettingsRepository, HomeRepository)
5. UseCases (SaveUserProfile, SaveDailyGoal, GetHomeData)
6. Blocs (RegisterBloc, DailyGoalBloc, HomeBloc, BottomNavBloc)
```

### Registrations hiện tại
| Type | Class | Scope |
|------|-------|-------|
| FlutterSecureStorage | - | Singleton |
| Dio | - | Singleton |
| AppDatabase | - | Singleton |
| AppSettingsDao | (AppDatabase) | LazySingleton |
| HomeDao | (AppDatabase) | LazySingleton |
| AppSettingsRepository | AppSettingsRepositoryImpl(dao) | LazySingleton |
| HomeRepository | HomeRepositoryImpl(dao) | LazySingleton |
| SaveUserProfileUseCase | (AppSettingsRepository) | LazySingleton |
| SaveDailyGoalUseCase | (AppSettingsRepository) | LazySingleton |
| GetHomeDataUseCase | (HomeRepository, AppSettingsRepository) | LazySingleton |
| RegisterBloc | (SaveUserProfileUseCase) | Factory |
| DailyGoalBloc | (SaveDailyGoalUseCase) | Factory |
| HomeBloc | (GetHomeDataUseCase) | Factory |
| BottomNavBloc | - | Factory |

### Cách dùng
```dart
// Lấy instance
final bloc = injector<HomeBloc>();

// Trong widget (dùng BlocProvider)
BlocProvider(create: (_) => injector<HomeBloc>()..add(LoadHomeDataEvent()))
```

## Routing - GoRouter (`lib/router.dart`)

### Routes hiện tại
| Path | Screen | Mô tả |
|------|--------|--------|
| `/` | RegisterScreen | Trang đăng ký (initial) |
| `/daily-goal` | DailyGoalScreen | Chọn mục tiêu hàng ngày |
| `/home` | HomeScreen | Trang chủ |

### Navigate
```dart
context.go('/home');
context.push('/daily-goal');
```

## Template: Thêm feature mới
```
1. Tạo Entity (nếu cần) → domain/entities/
2. Tạo Repository interface → domain/repositories/
3. Tạo UseCase → domain/usecases/
4. Tạo DAO → data/data_sources/local/
5. Tạo Repository impl → data/repositories/
6. Tạo BLoC (event + state + bloc) → presentation/views/<feature>/bloc/
7. Tạo Screen + Widgets → presentation/views/<feature>/
8. Đăng ký DI → injector.dart (theo thứ tự)
9. Thêm route → router.dart
```
