# テーブル設計

## companies テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| name         | string     | null: false                    |
| opening_time | time       | null: false                    |
| closing_time | time       | null: false                    |
| admin        | references | null: false, foreign_key: true |

### Association

- belongs_to :admin

## admins テーブル

| Column             | Type   | Options     |
| ------------------ | ------ | ----------- |
| number             | string | null: false |
| last_name          | string | null: false |
| first_name         | string | null: false |
| email              | string |             |
| encrypted_password | string | null: false |

### Association

- has_one  :companies
- has_many :employees

## employees テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| number             | string     | null: false                    |
| last_name          | string     | null: false                    |
| first_name         | string     | null: false                    |
| email              | string     |                                |
| encrypted_password | string     | null: false                    |
| admin              | references | null: false, foreign_key: true |

### Association

- belongs_to :admin

## admin_work_patterns テーブル

| Column         | Type   | Options     |
| -------------- | ------ | ----------- |
| work_pattern_a | string | null: false |

## employee_work_patterns テーブル

| Column         | Type   | Options     |
| -------------- | ------ | ----------- |
| work_pattern_a | string | null: false |

## work_schedules テーブル

## request_days_off テーブル