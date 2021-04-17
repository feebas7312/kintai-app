# アプリ名
勤務計画自動計算アプリ

# 概要
売場の責任者とスタッフのユーザー情報と出勤パターンを登録すれば、ボタン一つで勤務計画を作成できる。

# 本番環境
URL:http://54.178.16.210/

責任者テストユーザー
- 社員番号:351550
- パスワード:password

スタッフテストユーザー
- 社員番号:F351551
- パスワード:password

# 制作背景（意図）
小売業で人手不足や残業が多いことが問題になっている企業があるので、規則性があり自動化できるものはシステム化して業務の効率性を上げる。出勤時間が変動する小売業の勤務計画の作成を自動化することで、他の業務に時間を使えるようにする。

# DEMO
## スタッフ登録
![スタッフ登録](https://i.gyazo.com/e58379379c9fca84a06968e350ce46e0.gif)

- 責任者のアカウントを作成後、スタッフ一覧ページ右下の「スタッフ追加」ボタンからスタッフを追加する。
- 責任者のみがスタッフのアカウントを作成できる。

## 出勤パターン追加
![出勤パターン追加](https://i.gyazo.com/934f4d190a4fe12975e757f608c181e3.gif)

- 会社情報ページ右下の「パターン追加」ボタンから、一定で人手が必要な時間帯を登録する。

## 全スタッフの出勤パターン登録
![出勤パターン登録](https://i.gyazo.com/1c992bce26a1243422a597f1d7ad4058.gif)

- 登録した出勤パターンの中から、スタッフ毎に出勤可能な時間帯にチェックを入れて登録する。

## 勤務計画作成
![勤務計画作成](https://i.gyazo.com/6462fb043d61ba5ca918d6634e251f00.gif)

- 勤務計画作成ページの「計算」ボタンを押すと、自動で勤務計画が作成される。
- 必要な場合は手入力で追加し、最後に保存ボタンを押す。
- 会社情報に登録した締日の翌日から１ヶ月分の勤務計画が作成できる。

## 勤務計画閲覧
![勤務計画閲覧](https://i.gyazo.com/bd15fbb11a06354cdaa39d8c884ecf04.gif)

- 保存した勤務計画を月度で検索して閲覧可能。

# 工夫したポイント
- 勤務計画の自動計算機能は5連勤以上にはならないように調整している。
- 2年より前の勤務計画は自動で削除される。

# 実装予定の内容・課題や今後実装したい機能
- 月間労働時間の計算機能
- 所定労働時間の登録機能
- 希望休登録機能
- チャット機能

# ER図
(https://i.gyazo.com/31d274091ff2ebe55e3643e73d7ab5e4.png)

# DB設計

## companies テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| name           | string     | null: false                    |
| postal_code    | string     |                                |
| address        | string     |                                |
| phone_number   | string     |                                |
| cutoff_date_id | integer    | null: false                    |
| opening_time   | time       | null: false                    |
| closing_time   | time       | null: false                    |
| admin          | references | null: false, foreign_key: true |

### Association

- belongs_to :admin
- has_many   :work_patterns

## admins テーブル

| Column               | Type    | Options     |
| -------------------- | ------- | ----------- |
| number               | string  | null: false |
| last_name            | string  | null: false |
| first_name           | string  | null: false |
| birth_date           | date    | null: false |
| phone_number         | string  |             |
| email                | string  |             |
| encrypted_password   | string  | null: false |
| joining_date         | date    | null: false |
| employment_status_id | integer | null: false |
| salary_system_id     | integer | null: false |
| wages                | integer |             |

### Association

- has_one  :companies
- has_many :employees
- has_many :admin_work_patterns
- has_many :work_schedules

## employees テーブル

| Column               | Type       | Options                        |
| -------------------- | ---------- | ------------------------------ |
| number               | string     | null: false                    |
| last_name            | string     | null: false                    |
| first_name           | string     | null: false                    |
| birth_date           | date       | null: false                    |
| phone_number         | string     |                                |
| email                | string     |                                |
| encrypted_password   | string     | null: false                    |
| joining_date         | date       | null: false                    |
| employment_status_id | integer    | null: false                    |
| salary_system_id     | integer    | null: false                    |
| wages                | integer    |                                |
| admin                | references | null: false, foreign_key: true |

### Association

- belongs_to :admin
- has_many   :employee_work_patterns
- has_many   :work_schedules

## work_patterns テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| start_time | string     | null: false                    |
| end_time   | string     | null: false                    |
| break_time | integer    | null: false                    |
| work_time  | integer    | null: false                    |
| company    | references | null: false, foreign_key: true |

### Association

- belongs_to :company
- has_many   :admin_work_patterns
- has_many   :employee_work_patterns

## admin_work_patterns テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| admin        | references | null: false, foreign_key: true |
| work_pattern | references | null: false, foreign_key: true |
| possibility  | boolean    | null: false, default: false    |

### Association

- belongs_to :admin
- belongs_to :work_pattern

## employee_work_patterns テーブル

| Column       | Type       | Options                        |
| ------------ | ---------- | ------------------------------ |
| employee     | references | null: false, foreign_key: true |
| work_pattern | references | null: false, foreign_key: true |
| possibility  | boolean    | null: false, default: false    |

### Association

- belongs_to :employee
- belongs_to :work_pattern

## work_schedules テーブル

| Column     | Type       | Options                           |
| ---------- | ---------- | --------------------------------- |
| work_date  | date       | null: false                       |
| start_time | string     |                                   |
| end_time   | string     |                                   |
| break_time | integer    |                                   |
| work_time  | integer    |                                   |
| admin      | references | foreign_key: true, optional: true |
| employee   | references | foreign_key: true, optional: true |

### Association

- belongs_to :admin
- belongs_to :employee
