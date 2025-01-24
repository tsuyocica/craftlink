# データベース設計

## テーブル一覧

- Users（ユーザー管理機能）
- JobPosts（作業員募集機能）
- JobApplications（作業員の応募機能）

---

## Users テーブル

| Column        | Type   | Options      | 説明                               |
| ------------- | ------ | ------------ | ---------------------------------- |
| role          | string | null: false  | ユーザーの役割（施工主 or 作業員） |
| name          | string | null: false  | ユーザー名                         |
| experience    | text   |              | 経験・スキル（簡易テキスト）       |
| qualification | string |              | 資格（例: 第二種電気工事士）       |
| rating        | float  | default: 0.0 | 平均評価（レビュー機能は後で実装） |

### アソシエーション

- has_many :job_posts, dependent: :destroy (if role is 'owner')
- has_many :job_applications, dependent: :destroy (if role is 'worker')

---

## JobPosts テーブル（募集案件）

| Column      | Type       | Options                        | 説明                            |
| ----------- | ---------- | ------------------------------ | ------------------------------- |
| owner       | references | null: false, foreign_key: true | 施工主のユーザー ID（外部キー） |
| title       | string     | null: false                    | 募集タイトル                    |
| description | text       | null: false                    | 作業内容の詳細                  |
| num_workers | integer    | null: false                    | 募集人数                        |
| work_date   | datetime   | null: false                    | 作業日と時間                    |
| location    | string     | null: false                    | 作業場所（住所 or テキスト）    |
| pay_amount  | integer    | null: false                    | 報酬金額                        |
| pay_type    | string     | null: false,                   | 支払い方法（時給 or 固定額）    |
| status      | string     | default: 'open'                | 募集中 / 締切 / 成立            |

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

- JobPosts は Users（施工主）に属する（`belongs_to :user`）
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
