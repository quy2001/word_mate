# Database Schema - SQLite

## File: `lib/data/data_sources/local/app_database.dart`

Database name: `word_mate.db` | Version: `1`

## Bảng

### 1. AppSettings
Lưu cài đặt dạng key-value.
```sql
CREATE TABLE AppSettings (
  key TEXT PRIMARY KEY,
  value TEXT
)
```
**Keys đang dùng** (xem `lib/common/constants.dart`):
- `nickname` - Tên hiển thị
- `avatar` - Đường dẫn avatar
- `daily_goal` - Mục tiêu hàng ngày (lưu dạng string, parse sang int)

### 2. Topics
Phân loại từ vựng theo chủ đề.
```sql
CREATE TABLE Topics (
  topic_id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  color_hex TEXT DEFAULT '#FFFFFF',
  is_default INTEGER DEFAULT 0,
  created_at INTEGER
)
```

### 3. Cards
Thẻ từ vựng - trung tâm của app. Chứa cả thông tin SM-2.
```sql
CREATE TABLE Cards (
  card_id INTEGER PRIMARY KEY AUTOINCREMENT,
  topic_id INTEGER,                              -- FK → Topics
  word TEXT NOT NULL,
  meaning TEXT NOT NULL,
  type TEXT,                                      -- word type (noun, verb, ...)
  ipa TEXT,                                       -- phiên âm IPA
  example TEXT,
  image_path TEXT,
  audio_path TEXT,
  is_archived INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  -- SM-2 Algorithm fields
  next_review_ts INTEGER DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
  interval_days INTEGER DEFAULT 0,
  easiness_factor REAL DEFAULT 2.5,
  streak INTEGER DEFAULT 0,
  FOREIGN KEY (topic_id) REFERENCES Topics(topic_id) ON DELETE SET NULL
)
```

### 4. ReviewHistory
Lịch sử ôn tập của từng thẻ.
```sql
CREATE TABLE ReviewHistory (
  review_id INTEGER PRIMARY KEY AUTOINCREMENT,
  card_id INTEGER,                               -- FK → Cards (CASCADE DELETE)
  review_ts INTEGER NOT NULL,
  rating INTEGER NOT NULL,                       -- 0-5 (SM-2 quality)
  duration_ms INTEGER,                           -- thời gian trả lời
  FOREIGN KEY (card_id) REFERENCES Cards(card_id) ON DELETE CASCADE
)
```

## Quan hệ
```
Topics (1) ──< (N) Cards (1) ──< (N) ReviewHistory
```

## DAOs
- `AppSettingsDao` → CRUD key-value cho `AppSettings`
- `HomeDao` → Query tổng hợp: đếm cards hôm nay, streak, due-for-review, topics list
