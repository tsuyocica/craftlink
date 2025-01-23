class CreateJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :job_posts do |t|
      t.references :owner,      null: false, foreign_key: { to_table: :users } # 施工主
      t.string     :title,      null: false # 募集タイトル
      t.text       :description # 作業内容の詳細
      t.integer    :num_workers, default: 1 # 募集人数
      t.datetime   :work_date,  null: false # 作業日
      t.string     :location # 作業場所（住所）
      t.integer    :pay_amount, null: false # 報酬額
      t.string     :pay_type,   null: false # 支払い方法（時給 or 固定額）
      t.string     :status,     default: "募集中" # ステータス（募集中 / 締切 / 成立）

      t.timestamps
    end
  end
end