# Spaced Repetition - SM-2 Algorithm

## SM-2 Fields trong bảng Cards
| Field | Type | Default | Mô tả |
|-------|------|---------|--------|
| `next_review_ts` | INTEGER | now() | Timestamp lần ôn tiếp |
| `interval_days` | INTEGER | 0 | Khoảng cách ôn |
| `easiness_factor` | REAL | 2.5 | Hệ số dễ (min 1.3) |
| `streak` | INTEGER | 0 | Chuỗi đúng liên tiếp |

## Rating: 0-5
- 0-2: Sai → reset streak, interval=1
- 3-5: Đúng → tăng interval theo EF

## Query cards cần ôn
```sql
SELECT card_id, word, ipa, meaning FROM Cards
WHERE next_review_ts <= :nowTs AND is_archived = 0 LIMIT 10
```
File: `home_dao.dart` → `getDueForReviewWords()`

## ReviewHistory
Mỗi lần ôn: card_id, review_ts, rating(0-5), duration_ms
