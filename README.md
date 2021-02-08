# アプリ名
勤怠管理システム

# 概要
売場の責任者とスタッフのユーザー情報と出勤パターンを登録すれば、ボタン一つで勤務計画を作成できる。

# 本番環境
現在アプリ作成中

# 制作背景（意図）
小売業で人手不足や残業が多いことが問題になっている企業があるので、規則性があり自動化できるものはシステム化して業務の効率性を上げる。出勤時間が変動する小売業の勤務計画の作成を自動化することで、他の業務に時間を使えるようにする。

# DEMO
現在アプリ作成中

# 工夫したポイント
現在アプリ作成中

# 実装予定の内容・課題や今後実装したい機能
- ユーザー管理機能
- 勤務計画検索・閲覧機能
- 勤務計画作成機能
- 希望休登録機能

# DB設計

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
| joining_date       | date   | null: false |
| email              | string |             |
| encrypted_password | string | null: false |

### Association

- has_one  :companies
- has_many :employees
- has_many :admin_work_patterns
- has_many :work_patterns, through: admin_work_patterns
- has_many :work_schedules

## employees テーブル

| Column             | Type       | Options                        |
| ------------------ | ---------- | ------------------------------ |
| number             | string     | null: false                    |
| last_name          | string     | null: false                    |
| first_name         | string     | null: false                    |
| joining_date       | date       | null: false                    |
| email              | string     |                                |
| encrypted_password | string     | null: false                    |
| admin              | references | null: false, foreign_key: true |

### Association

- belongs_to :admin
- has_many   :employee_work_patterns
- has_many   :work_patterns, through: employee_work_patterns
- has_many   :work_schedules

## work_patterns テーブル

| Column         | Type   | Options     |
| -------------- | ------ | ----------- |
| work_pattern_a | string | null: false |
| work_pattern_b | string | null: false |
| work_pattern_c | string | null: false |

### Association

- has_many :admin_work_patterns
- has_many :admins, through: admin_work_patterns
- has_many :employee_work_patterns
- has_many :employees, through: employee_work_patterns

## admin_work_patterns テーブル

| Column          | Type       | Options     |
| --------------- | ---------- | ----------- |
| admin           | references | null: false |
| work_pattern    | references | null: false |

### Association

- belongs_to :admin
- belongs_to :work_pattern

## employee_work_patterns テーブル

| Column          | Type       | Options     |
| --------------- | ---------- | ----------- |
| employee        | references | null: false |
| work_pattern    | references | null: false |

### Association

- belongs_to :employee
- belongs_to :work_pattern

## work_schedules テーブル

| Column          | Type       | Options                           |
| --------------- | ---------- | --------------------------------- |
| work_date       | date       | null: false                       |
| work_start_time | string     | null: false                       |
| work_end_time   | string     | null: false                       |
| admin           | references | foreign_key: true, optional: true |
| employee        | references | foreign_key: true, optional: true |

### Association

- belongs_to :admin
- belongs_to :employee

## request_days_off テーブル