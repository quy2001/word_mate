# UI Conventions & Shared Widgets

## ScreenUtil Setup
- Design size: 375 x 812 (iPhone X)
- File: `lib/app.dart`
- Sử dụng: `16.w`, `20.h`, `14.sp`, `8.r` cho responsive

## Reusable Widgets (`lib/presentation/widgets/`)

### ButtonWidget (`button_widget.dart`)
Nút bấm chung, hỗ trợ gradient và nhiều style.

### PageIndicator (`page_indicator.dart`)
Chỉ báo trang cho PageView/onboarding flows.

### BottomNavBar (`bottom_nav/`)
Bottom navigation bar với BLoC riêng:
- `BottomNavBloc` - quản lý tab index
- `BottomNavEvent` - sự kiện đổi tab  
- `BottomNavState` - trạng thái tab hiện tại
- `AppBottomNavBar` - widget

## Register Screen Widgets (`presentation/views/register/widgets/`)
- `avatar_selector.dart` - Chọn avatar
- `custom_text_field.dart` - Text field tùy chỉnh
- `glass_container.dart` - Glassmorphism container
- `glowing_text.dart` - Text với hiệu ứng phát sáng
- `gradient_background.dart` - Background gradient
- `page_indicator.dart` - Page indicator (local)

## Daily Goal Widgets (`presentation/views/daily_goal/widgets/`)
- `goal_adjuster.dart` - Tăng/giảm mục tiêu (+/-)
- `goal_chips.dart` - Chips chọn nhanh (5, 10, 15, 20)
- `monthly_estimation_badge.dart` - Badge hiển thị ước tính tháng

## Home Widgets (`presentation/views/home/widgets/`)
- `greeting_card.dart` - Card chào mừng user
- `stats_row.dart` - Row hiển thị thống kê (streak, total words)
- `today_goal_card.dart` - Card tiến độ mục tiêu hôm nay
- `due_for_review_card.dart` - Card từ cần ôn tập
- `topic_list_section.dart` - Section danh sách chủ đề

## Animation
- Package: `animate_do` ^4.2.0
- Dùng các widget: `FadeIn`, `FadeInUp`, `FadeInDown`, `SlideInLeft`, `BounceInDown`, etc.

## Assets
- Generated: `lib/gen/assets.gen.dart`
- Paths: `assets/images/`, `assets/icons/`
- Sử dụng: `Assets.images.<name>`, `Assets.icons.<name>`

## Conventions
1. Screen widget là `StatelessWidget`, tạo `BlocProvider` rồi delegate sang `_<Feature>View`
2. Sub-widgets nhận data qua constructor, KHÔNG truy cập BLoC trực tiếp
3. Dùng `flutter_screenutil` cho TẤT CẢ dimension (width, height, font, radius)
4. Dùng `animate_do` cho entrance animations
5. Glassmorphism style cho các container chính
