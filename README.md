# アプリケーション名
# アプリケーション概要
売場の責任者とスタッフのユーザー情報と出勤パターンを登録すれば、ボタン一つで勤務計画を作成できる。
# URL
# テスト用アカウント
# 利用方法
# 目指した課題解決
出勤時間が変動する小売業の勤務計画の作成を自動化することで、他の業務に時間を使えるようにする。
# 洗い出した要件
# 実装した機能についてのGIFと説明
# 実装予定の機能
# データベース設計
# ローカルでの動作方法


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
| joining_date       | date   | null: false |
| email              | string |             |
| encrypted_password | string | null: false |

### Association

- has_one  :companies
- has_many :employees
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
- has_many   :work_schedules

## admin_work_patterns テーブル

| Column         | Type   | Options     |
| -------------- | ------ | ----------- |
| work_pattern_a | string | null: false |

## employee_work_patterns テーブル

| Column         | Type   | Options     |
| -------------- | ------ | ----------- |
| work_pattern_a | string | null: false |

## work_schedules テーブル

| Column          | Type       | Options     |
| --------------- | ---------- | ----------- |
| work_date       | date       | null: false |
| work_start_time | time       | null: false |
| work_end_time   | time       | null: false |
| admin           | references |             |
| employee        | references |             |

### Association

- belongs_to :admin
- belongs_to :employee

## request_days_off テーブル