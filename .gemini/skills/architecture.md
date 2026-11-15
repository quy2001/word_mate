# Architecture - Clean Architecture + BLoC

## Cấu trúc thư mục
```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp.router + ScreenUtilInit
├── injector.dart                # GetIt DI container
├── router.dart                  # GoRouter routes
├── common/                      # Shared constants, utilities
│   ├── constants.dart           # Design sizes, setting keys
│   └── index.dart               # Barrel export
├── core/                        # Base classes, infrastructure
│   ├── data_state.dart          # DataState<T>, DataSuccess, DataFail
│   ├── usecase.dart             # UseCase<T, P> abstract class
│   ├── bloc_observer.dart       # AppBlocObserver (logging)
│   ├── resources/               # (reserved for themes, strings)
│   ├── usecase/                 # (reserved for extended base usecases)
│   └── index.dart               # Barrel export
├── data/                        # Data Layer
│   ├── data_sources/local/      # DAOs + Database
│   ├── models/                  # Data models (JSON serialization)
│   ├── repositories/            # Repository implementations
│   └── services/                # External services
├── domain/                      # Domain Layer
│   ├── entities/                # Business entities
│   ├── repositories/            # Repository interfaces (abstract)
│   └── usecases/                # Business logic use cases
├── gen/                         # Generated code (flutter_gen)
│   └── assets.gen.dart          # Asset paths
└── presentation/                # Presentation Layer
    ├── views/                   # Screens (feature-based)
    │   ├── register/            # Register screen + bloc + widgets
    │   ├── daily_goal/          # Daily goal screen + bloc + widgets
    │   └── home/                # Home screen + bloc + widgets
    └── widgets/                 # Shared/reusable widgets
        ├── bottom_nav/          # Bottom navigation + bloc
        ├── button_widget.dart   # Common button
        └── page_indicator.dart  # Page indicator
```

## Luồng dữ liệu (Data Flow)
```
UI (Widget) → BLoC Event → BLoC Handler → UseCase → Repository Interface
                                                          ↓
                                              Repository Implementation
                                                          ↓
                                                    DAO → SQLite
```

## Quy tắc kiến trúc
1. **Domain layer KHÔNG phụ thuộc** vào data hoặc presentation
2. **Repository interfaces** ở domain, implementations ở data
3. **BLoC pattern**: Event → Bloc → State (dùng Equatable)
4. **Feature-based structure**: Mỗi screen = thư mục riêng chứa `bloc/`, `widgets/`, và `*_screen.dart`
5. **DI**: Tất cả dependency đều đăng ký trong `injector.dart` theo thứ tự: DB → DAO → Repo → UseCase → Bloc
