#　工夫したところ

- エラーメッセージを各フォーム下部に出力したこと
- CSS に Bootstrap を採用した

# データベース設計

## テーブル一覧

- Users（ユーザー管理機能）
- JobPosts（作業員募集機能）
- JobApplications（作業員の応募機能）

---

## Users テーブル

| Column        | Type   | Options     | 説明                               |
| ------------- | ------ | ----------- | ---------------------------------- |
| role          | string | null: false | ユーザーの役割（依頼者 or 作業員） |
| name          | string | null: false | ユーザー名                         |
| experience    | text   |             | 経験・スキル（簡易テキスト）       |
| qualification | string |             | 資格（例: 第二種電気工事士）       |

### アソシエーション

- has_many :job_posts, dependent: :destroy (if role is 'owner')
- has_many :job_applications, dependent: :destroy (if role is 'worker')
- has_many :reviews rating

---

## JobPosts テーブル（募集案件）

| Column           | Type       | Options                        | 説明                               |
| ---------------- | ---------- | ------------------------------ | ---------------------------------- |
| owner            | references | null: false, foreign_key: true | 依頼者のユーザー ID（外部キー）    |
| work_title       | string     | null: false                    | 募集タイトル                       |
| work_description | text       | null: false                    | 作業内容の詳細                     |
| num_workers      | integer    | null: false                    | 募集人数                           |
| work_start_date  | date       | default: 'today'               | 作業開始日                         |
| work_end_date    | date       | default: 'today'               | 作業終了日                         |
| work_start_time  | time       | default: '8:00'                | 作業開始時刻                       |
| work_end_time    | time       | default: '17:00'               | 作業終了時刻                       |
| work_location    | string     | null: false                    | 作業場所の住所                     |
| work_latitude    | decimal    | null: false                    | 作業場所の緯度                     |
| work_longitude   | decimal    | null: false                    | 作業場所の経度                     |
| work_pay_amount  | integer    | null: false                    | 報酬金額                           |
| work_pay_type    | string     | null: false                    | 支払い方法（時給 / 日給 / 固定額） |
| work_status      | string     | default: 'opening'             | 募集中 / 受付終了                  |

### アソシエーション

- belongs_to :user (as owner)
- has_many :job_applications, dependent: :destroy

---

## JobApplications テーブル（作業員の応募）

| Column   | Type       | Options                        | 説明                            |
| -------- | ---------- | ------------------------------ | ------------------------------- |
| job_post | references | null: false, foreign_key: true | 募集案件 ID（外部キー）         |
| worker   | references | null: false, foreign_key: true | 応募した作業員の ID（外部キー） |
| message  | text       | null: false                    | 応募メッセージ                  |
| status   | string     | default: 'pending'             | 応募中 / 承認 / 却下 / 確定     |

### アソシエーション

- belongs_to :job_post
- belongs_to :user (as worker)

---

## 必要なリレーション

- JobPosts は Users（依頼者）に属する（`belongs_to :user`）
- JobApplications は JobPosts（募集案件）と Users（作業員）に属する
  （`belongs_to :job_post`、`belongs_to :user`）

---

## MVP での省略点（今後拡張する要素）

✅ Google マップ API を使った位置情報の緯度・経度管理（MVP では `location` に住
所テキスト） ✅ レビュー・評価機能（後で `reviews` テーブルを追加） ✅ 決済機能
（後で `payments` テーブルを追加）

### 次のステップ

- モデルの作成（`JobPost`, `JobApplication`）
- マイグレーションファイルの作成
- ルーティング・コントローラーの実装
