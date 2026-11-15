# Word Mate - Agent STYLEGUIDE

## Luôn đọc skills trước khi code
Trước khi thêm feature hoặc sửa code, hãy đọc các skill files trong `.gemini/skills/` để hiểu kiến trúc, pattern, và conventions đã được thiết lập.

## Checklist khi thêm feature mới
- [ ] Đọc `architecture.md` để hiểu cấu trúc layers
- [ ] Đọc `bloc_patterns.md` để theo đúng template
- [ ] Đọc `di_and_routing.md` để biết cách đăng ký DI và thêm route
- [ ] Đọc `database_schema.md` nếu cần thao tác DB
- [ ] Đọc `file_map.md` để tìm file nhanh
- [ ] Đọc `coding_conventions.md` để theo naming/style
- [ ] Đọc `testing.md` để viết test cho feature mới
- [ ] Chạy `flutter test` để đảm bảo không break test hiện tại

## Nguyên tắc vàng
1. **Domain KHÔNG import data/presentation** - vi phạm = bug kiến trúc
2. **Mỗi BLoC = 1 Feature** - không gộp logic khác feature
3. **DI đăng ký theo thứ tự** - DB → DAO → Repo → UseCase → Bloc
4. **ScreenUtil cho mọi dimension** - KHÔNG hardcode pixel
5. **Equatable cho Event & State** - đảm bảo so sánh đúng
