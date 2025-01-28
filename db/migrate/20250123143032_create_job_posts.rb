class CreateJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :job_posts do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users } # 依頼者（外部キー）

      # 基本情報
      t.string  :work_title,       null: false # 募集タイトル
      t.text    :work_description, null: false # 作業内容の詳細
      t.integer :num_workers,      null: false, default: 1 # 募集人数（1〜10人）

      # 作業日程
      t.date    :work_start_date, default: -> { 'CURRENT_DATE' } # 作業開始日
      t.date    :work_end_date,   default: -> { 'CURRENT_DATE' } # 作業終了日
      t.time    :work_start_time, default: -> { "'08:00'" } # 作業開始時刻
      t.time    :work_end_time,   default: -> { "'17:00'" } # 作業終了時刻

      # 作業場所（Google Maps で取得）
      t.string  :work_location,  null: false # 作業場所の住所
      t.decimal :work_latitude,  null: false, precision: 10, scale: 6 # 緯度
      t.decimal :work_longitude, null: false, precision: 10, scale: 6 # 経度

      # 報酬情報
      t.integer :work_pay_amount, null: false # 報酬金額（3,000円〜500,000円）
      t.string  :work_pay_type,   null: false # 支払い方法（時給 / 日給 / 固定額）

      # ステータス
      t.string :work_status, default: "open" # 募集中 / 締切 / 成立

      t.timestamps
    end
  end
end