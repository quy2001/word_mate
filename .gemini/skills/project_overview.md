# Word Mate - Project Overview

## Mô tả
Word Mate là ứng dụng Flutter học từ vựng tiếng Anh, sử dụng thuật toán Spaced Repetition (SM-2) để lập lịch ôn tập. App hoạt động hoàn toàn offline với SQLite.

## Tech Stack
| Layer | Công nghệ |
|-------|-----------|
| Framework | Flutter SDK ^3.6.2 |
| State Management | flutter_bloc (BLoC pattern) |
| DI | get_it (Service Locator) |
| Routing | go_router 15.1.3 |
| Database | sqflite (SQLite) |
| Responsive | flutter_screenutil 5.9.3 |
| Loading | flutter_easyloading |
| Animation | animate_do ^4.2.0 |
| Assets Gen | flutter_gen_runner 5.11.0 |
| Serialization | json_serializable + freezed |
| SVG | flutter_svg ^2.0.17 |
| HTTP | dio + retrofit (chuẩn bị cho API) |
| Logging | logger + pretty_dio_logger |

## Design Size
- Width: **375.0**
- Height: **812.0**
- (iPhone X design reference)

## Entry Point
- `lib/main.dart` → `configureDependencies()` → `runApp(App())`
