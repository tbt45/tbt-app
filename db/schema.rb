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

ActiveRecord::Schema[8.1].define(version: 2026_06_21_223600) do
  create_table "exercise_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "calories_burned", null: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes"
    t.string "name", null: false
    t.date "recorded_on", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "recorded_on" ], name: "index_exercise_entries_on_user_id_and_recorded_on"
    t.index [ "user_id" ], name: "index_exercise_entries_on_user_id"
  end

  create_table "exercise_templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "calories_burned", null: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "name" ], name: "index_exercise_templates_on_user_id_and_name", unique: true
    t.index [ "user_id" ], name: "index_exercise_templates_on_user_id"
  end

  create_table "goals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "daily_calorie_target"
    t.date "effective_on", null: false
    t.decimal "target_weight", precision: 5, scale: 1
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "effective_on" ], name: "index_goals_on_user_id_and_effective_on", unique: true
    t.index [ "user_id" ], name: "index_goals_on_user_id"
  end

  create_table "meal_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "calories", null: false
    t.datetime "created_at", null: false
    t.string "meal_type"
    t.string "name", null: false
    t.integer "quantity", default: 1, null: false
    t.date "recorded_on", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "recorded_on" ], name: "index_meal_entries_on_user_id_and_recorded_on"
    t.index [ "user_id" ], name: "index_meal_entries_on_user_id"
  end

  create_table "meal_templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "calories", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "user_id", "name" ], name: "index_meal_templates_on_user_id_and_name", unique: true
    t.index [ "user_id" ], name: "index_meal_templates_on_user_id"
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "ip_address"
    t.boolean "remember_me", default: true, null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index [ "expires_at" ], name: "index_sessions_on_expires_at"
    t.index [ "user_id" ], name: "index_sessions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index [ "email_address" ], name: "index_users_on_email_address", unique: true
  end

  create_table "weight_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "body_fat_percentage", precision: 4, scale: 1
    t.datetime "created_at", null: false
    t.date "recorded_on", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.decimal "weight", precision: 5, scale: 1, null: false
    t.index [ "user_id", "recorded_on" ], name: "index_weight_entries_on_user_id_and_recorded_on", unique: true
    t.index [ "user_id" ], name: "index_weight_entries_on_user_id"
  end

  add_foreign_key "exercise_entries", "users"
  add_foreign_key "exercise_templates", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "meal_entries", "users"
  add_foreign_key "meal_templates", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "weight_entries", "users"
end
