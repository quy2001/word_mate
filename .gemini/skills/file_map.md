# File Map - Quick Reference

## Tìm file nhanh theo mục đích

### Configuration
| File | Mục đích |
|------|----------|
| `pubspec.yaml` | Dependencies |
| `analysis_options.yaml` | Lint rules |
| `lib/main.dart` | Entry point, HttpOverrides |
| `lib/app.dart` | MaterialApp, ScreenUtil, EasyLoading |
| `lib/injector.dart` | GetIt DI registrations |
| `lib/router.dart` | GoRouter routes |

### Core
| File | Mục đích |
|------|----------|
| `lib/core/data_state.dart` | DataState, DataSuccess, DataFail |
| `lib/core/usecase.dart` | UseCase<T,P> abstract |
| `lib/core/bloc_observer.dart` | BLoC logging |

### Data Layer
| File | Mục đích |
|------|----------|
| `lib/data/data_sources/local/app_database.dart` | SQLite schema (4 tables) |
| `lib/data/data_sources/local/app_settings_dao.dart` | Key-value CRUD |
| `lib/data/data_sources/local/card_dao.dart` | Cards + Topics CRUD |
| `lib/data/data_sources/local/home_dao.dart` | Home stats queries |
| `lib/data/repositories/app_settings_repository_impl.dart` | Settings repo |
| `lib/data/repositories/card_repository_impl.dart` | Card repo |
| `lib/data/repositories/home_repository_impl.dart` | Home repo |

### Domain Layer
| File | Mục đích |
|------|----------|
| `lib/domain/repositories/app_settings_repository.dart` | Settings interface |
| `lib/domain/repositories/card_repository.dart` | Card interface |
| `lib/domain/repositories/home_repository.dart` | Home interface |
| `lib/domain/usecases/save_user_profile_usecase.dart` | Save nickname+avatar |
| `lib/domain/usecases/save_daily_goal_usecase.dart` | Save daily goal |
| `lib/domain/usecases/add_card_usecase.dart` | Add new word card |
| `lib/domain/usecases/get_home_data_usecase.dart` | Aggregate home data |

### Presentation Layer
| Feature | Screen | BLoC | Widgets |
|---------|--------|------|---------|
| Register | `views/register/register_screen.dart` | `bloc/register_bloc.dart` | avatar_selector, custom_text_field, glass_container, glowing_text, gradient_background, page_indicator |
| Daily Goal | `views/daily_goal/daily_goal_screen.dart` | `bloc/daily_goal_bloc.dart` | goal_adjuster, goal_chips, monthly_estimation_badge |
| Add Word | `views/add_word/add_word_bottom_sheet.dart` | `bloc/add_word_bloc.dart` | (inline in bottom sheet) |
| Home | `views/home/home_screen.dart` | `bloc/home_bloc.dart` | greeting_card, stats_row, today_goal_card, due_for_review_card, topic_list_section |
| Bottom Nav | - | `widgets/bottom_nav/bottom_nav_bloc.dart` | app_bottom_nav_bar |
| Shared | - | - | button_widget, page_indicator |

### Generated
| File | Mục đích |
|------|----------|
| `lib/gen/assets.gen.dart` | Asset paths (images, icons) |

### Constants
| File | Mục đích |
|------|----------|
| `lib/common/constants.dart` | Design size, setting keys |
