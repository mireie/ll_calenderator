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

ActiveRecord::Schema[7.0].define(version: 2024_04_28_225847) do
  create_table "games", force: :cascade do |t|
    t.datetime "start_time"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "field"
    t.integer "league_id", null: false
    t.integer "location_id"
    t.integer "home_team_id", null: false
    t.integer "away_team_id", null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["league_id"], name: "index_games_on_league_id"
    t.index ["location_id"], name: "index_games_on_location_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "title"
    t.string "sport"
    t.string "description"
    t.string "days"
    t.datetime "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id", null: false
    t.index ["organization_id"], name: "index_leagues_on_organization_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "base_url"
    t.string "leagues_path"
    t.string "teams_path"
    t.string "schedule_path"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "league_id", null: false
    t.index ["league_id"], name: "index_teams_on_league_id"
  end

  add_foreign_key "games", "leagues"
  add_foreign_key "games", "locations"
  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "leagues", "organizations"
  add_foreign_key "teams", "leagues"
end
