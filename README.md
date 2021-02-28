# アプリ名
勤怠管理システム

# 概要
売場の責任者とスタッフのユーザー情報と出勤パターンを登録すれば、ボタン一つで勤務計画を作成できる。

# 本番環境
現在アプリ作成中

# 制作背景（意図）
小売業で人手不足や残業が多いことが問題になっている企業があるので、規則性があり自動化できるものはシステム化して業務の効率性を上げる。出勤時間が変動する小売業の勤務計画の作成を自動化することで、他の業務に時間を使えるようにする。

# DEMO
## スタッフ登録
![スタッフ登録](https://i.gyazo.com/5e109432d341284c8f2b8da5bd1b868a.gif)

## 出勤パターン追加
![出勤パターン追加](https://i.gyazo.com/2830ea2ff05671b34607e083623ee37d.gif)

## 出勤パターン登録
![出勤パターン登録](https://i.gyazo.com/4cd486c83e27bb185bf521cb9b53fe33.gif)

## 勤務計画作成
![勤務計画作成](https://i.gyazo.com/7296e53e20f6d9cf2cd0f541be5ac2a4.gif)

## 勤務計画閲覧
![勤務計画閲覧]()

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
- has_many   :work_patterns

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
- has_many   :work_schedules

## work_patterns テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| start_time | string     | null: false                    |
| end_time   | string     | null: false                    |
| company    | references | null: false, foreign_key: true |

### Association

- belongs_to :company
- has_many   :admin_work_patterns
- has_many   :employee_work_patterns

## admin_work_patterns テーブル

| Column          | Type       | Options                        |
| --------------- | ---------- | ------------------------------ |
| admin           | references | null: false, foreign_key: true |
| work_pattern    | references | null: false, foreign_key: true |
| possibility     | boolean    | null: false, default: false    |

### Association

- belongs_to :admin
- belongs_to :work_pattern

## employee_work_patterns テーブル

| Column          | Type       | Options                        |
| --------------- | ---------- | ------------------------------ |
| employee        | references | null: false, foreign_key: true |
| work_pattern    | references | null: false, foreign_key: true |
| possibility     | boolean    | null: false, default: false    |

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
