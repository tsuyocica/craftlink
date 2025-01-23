class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.references :job_post, null: false, foreign_key: true # 募集案件への外部キー
      t.references :worker,   null: false, foreign_key: { to_table: :users } # 応募者（作業員）
      t.text :message # 応募メッセージ
      t.string :status, default: "応募中" # ステータス（応募中 / 承認 / 却下）

      t.timestamps
    end
  end
end