# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_11_104606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_match_turns", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "turn_number", default: 1, null: false
    t.integer "player", default: 0, null: false
    t.jsonb "move"
    t.jsonb "boards", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_game_match_turns_on_match_id"
  end

  create_table "game_matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ruleset", default: 0, null: false
    t.bigint "black_player_id"
    t.bigint "white_player_id"
    t.integer "state", default: 0, null: false
    t.datetime "started_at"
    t.index ["black_player_id"], name: "index_game_matches_on_black_player_id"
    t.index ["white_player_id"], name: "index_game_matches_on_white_player_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
