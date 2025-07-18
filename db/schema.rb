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

ActiveRecord::Schema[7.1].define(version: 2025_05_24_061411) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "photo_id"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["photo_id"], name: "index_comments_on_photo_id"
  end

  create_table "follow_requests", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_follow_requests_on_recipient_id"
    t.index ["sender_id"], name: "index_follow_requests_on_sender_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer "photo_id"
    t.integer "fan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fan_id"], name: "index_likes_on_fan_id"
    t.index ["photo_id"], name: "index_likes_on_photo_id"
  end

  create_table "photos", force: :cascade do |t|
    t.string "image"
    t.text "caption"
    t.integer "owner_id"
    t.integer "comments_count"
    t.integer "likes_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_photos_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "private"
    t.integer "photos_count"
    t.integer "comments_count"
    t.integer "likes_count"
    t.integer "sent_follow_requests_count"
    t.integer "received_follow_requests_count"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
