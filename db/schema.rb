# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_01_24_025101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "job_applications", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "worker_id", null: false
    t.text "message"
    t.string "status", default: "応募中"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_job_applications_on_job_post_id"
    t.index ["worker_id"], name: "index_job_applications_on_worker_id"
  end

  create_table "job_posts", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "work_title", null: false
    t.text "work_description", null: false
    t.integer "num_workers", default: 1, null: false
    t.date "work_start_date", default: -> { "CURRENT_DATE" }
    t.date "work_end_date", default: -> { "CURRENT_DATE" }
    t.time "work_start_time", default: "2000-01-01 08:00:00"
    t.time "work_end_time", default: "2000-01-01 17:00:00"
    t.string "work_location", null: false
    t.decimal "work_latitude", precision: 10, scale: 6, null: false
    t.decimal "work_longitude", precision: 10, scale: 6, null: false
    t.integer "work_pay_amount", null: false
    t.string "work_pay_type", null: false
    t.string "work_status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_job_posts_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.string "role", default: "worker", null: false
    t.string "qualification", default: ""
    t.text "experience", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "job_applications", "job_posts"
  add_foreign_key "job_applications", "users", column: "worker_id"
  add_foreign_key "job_posts", "users", column: "owner_id"
end
