# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 0) do

  create_table "clients", force: :cascade do |t|
    t.string   "title",            limit: 255,             null: false
    t.string   "url",              limit: 255
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
    t.integer  "created_user_id",  limit: 4,   default: 0, null: false
    t.datetime "created_date",                             null: false
    t.integer  "modified_user_id", limit: 4,   default: 0, null: false
    t.datetime "modified_date",                            null: false
  end

  add_index "clients", ["title"], name: "title", unique: true, using: :btree

  create_table "currencies", force: :cascade do |t|
    t.string  "code",       limit: 5,                   null: false
    t.string  "title",      limit: 255,                 null: false
    t.string  "symbol",     limit: 10,                  null: false
    t.boolean "is_infront", limit: 1,   default: false, null: false
  end

  create_table "currencies_exchanges", force: :cascade do |t|
    t.integer  "from_currency_id", limit: 4,                          null: false
    t.integer  "to_currency_id",   limit: 4,                          null: false
    t.decimal  "rate",                       precision: 13, scale: 4, null: false
    t.integer  "modified_user_id", limit: 4,                          null: false
    t.datetime "modified_date",                                       null: false
  end

  add_index "currencies_exchanges", ["from_currency_id"], name: "from_currency_id", using: :btree
  add_index "currencies_exchanges", ["to_currency_id"], name: "to_currency_id", using: :btree

  create_table "engagement_models", force: :cascade do |t|
    t.string  "title",      limit: 255, null: false
    t.boolean "has_minmax", limit: 1,   null: false
  end

  create_table "estimates", force: :cascade do |t|
    t.string   "title",               limit: 255,                 null: false
    t.boolean  "is_signed",           limit: 1,   default: false, null: false
    t.integer  "rate_id",             limit: 4,                   null: false
    t.integer  "engagement_model_id", limit: 4,                   null: false
    t.integer  "client_id",           limit: 4,                   null: false
    t.integer  "project_id",          limit: 4,                   null: false
    t.integer  "owner_user_id",       limit: 4,                   null: false
    t.integer  "created_user_id",     limit: 4,                   null: false
    t.datetime "created_date",                                    null: false
    t.integer  "modified_user_id",    limit: 4,                   null: false
    t.datetime "modified_date",                                   null: false
  end

  add_index "estimates", ["client_id"], name: "client_id", using: :btree
  add_index "estimates", ["engagement_model_id"], name: "engagement_model_id", using: :btree
  add_index "estimates", ["owner_user_id"], name: "owner_user_id", using: :btree
  add_index "estimates", ["project_id"], name: "project_id", using: :btree
  add_index "estimates", ["rate_id"], name: "rate_id", using: :btree

  create_table "estimates_assumptions", force: :cascade do |t|
    t.integer "estimate_id", limit: 4,     null: false
    t.text    "title",       limit: 65535, null: false
  end

  add_index "estimates_assumptions", ["estimate_id"], name: "estimate_id", using: :btree

  create_table "estimates_lines", force: :cascade do |t|
    t.integer  "estimate_id",           limit: 4,                   null: false
    t.integer  "estimates_sections_id", limit: 4,                   null: false
    t.integer  "technology_id",         limit: 4,     default: 0
    t.integer  "position_id",           limit: 4,                   null: false
    t.integer  "line_number",           limit: 4,     default: 1,   null: false
    t.text     "line",                  limit: 65535,               null: false
    t.float    "hours_min",             limit: 24,    default: 0.0
    t.float    "hours_max",             limit: 24,    default: 0.0
    t.integer  "created_user_id",       limit: 4,                   null: false
    t.datetime "created_date",                                      null: false
  end

  add_index "estimates_lines", ["estimate_id"], name: "estimate_id", using: :btree
  add_index "estimates_lines", ["estimates_sections_id"], name: "estimates_sections_id", using: :btree
  add_index "estimates_lines", ["position_id"], name: "position_id", using: :btree
  add_index "estimates_lines", ["technology_id"], name: "technology_id", using: :btree

  create_table "estimates_sections", force: :cascade do |t|
    t.integer "estimate_id",        limit: 4,     null: false
    t.integer "estimates_sheet_id", limit: 4,     null: false
    t.text    "title",              limit: 65535, null: false
  end

  add_index "estimates_sections", ["estimate_id"], name: "estimate_id", using: :btree
  add_index "estimates_sections", ["estimates_sheet_id"], name: "estimates_sheet_id", using: :btree

  create_table "estimates_sheets", force: :cascade do |t|
    t.integer "estimate_id", limit: 4,     null: false
    t.text    "title",       limit: 65535, null: false
  end

  add_index "estimates_sheets", ["estimate_id"], name: "estimate_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string "subject_class", limit: 50,    null: false
    t.string "action",        limit: 50,    null: false
    t.string "name",          limit: 255,   null: false
    t.text   "description",   limit: 65535, null: false
  end

  create_table "positions", force: :cascade do |t|
    t.integer "technology_id", limit: 4,               null: false
    t.integer "complexity",    limit: 1,   default: 0, null: false
    t.string  "title",         limit: 255,             null: false
    t.integer "is_am",         limit: 1,   default: 0, null: false
    t.integer "is_pdm",        limit: 1,   default: 0, null: false
    t.boolean "is_rated",      limit: 1,               null: false
  end

  add_index "positions", ["technology_id"], name: "technology_id", using: :btree

  create_table "project_statuses", force: :cascade do |t|
    t.string "title", limit: 50, null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title",                      limit: 255,                   null: false
    t.integer  "client_id",                  limit: 4,                     null: false
    t.integer  "project_status_id",          limit: 4,                     null: false
    t.integer  "account_manager_user_id",    limit: 4,     default: 0,     null: false
    t.integer  "production_manager_user_id", limit: 4,     default: 0
    t.integer  "project_owner_user_id",      limit: 4,     default: 0
    t.datetime "start_date_scheduled"
    t.datetime "start_date_actual"
    t.datetime "end_date_scheduled"
    t.datetime "end_date_actual"
    t.boolean  "internal_yn",                limit: 1,     default: false, null: false
    t.text     "rejection_reasons",          limit: 65535
    t.integer  "created_user_id",            limit: 4,                     null: false
    t.datetime "created_date",                                             null: false
    t.integer  "modified_user_id",           limit: 4,                     null: false
    t.datetime "modified_date",                                            null: false
  end

  add_index "projects", ["account_manager_user_id"], name: "account_manager_user_id", using: :btree
  add_index "projects", ["client_id"], name: "client_id", using: :btree
  add_index "projects", ["production_manager_user_id"], name: "production_manager_user_id", using: :btree
  add_index "projects", ["project_owner_user_id"], name: "project_owner_user_id", using: :btree
  add_index "projects", ["project_status_id"], name: "project_status_id", using: :btree

  create_table "projects_comments", force: :cascade do |t|
    t.integer  "project_id",       limit: 4,     null: false
    t.text     "comment",          limit: 65535
    t.integer  "modified_user_id", limit: 4,     null: false
    t.datetime "modified_date",                  null: false
  end

  add_index "projects_comments", ["modified_user_id"], name: "modified_user_id", using: :btree
  add_index "projects_comments", ["project_id"], name: "project_id", using: :btree

  create_table "projects_requests", force: :cascade do |t|
    t.integer  "project_id",       limit: 4,     null: false
    t.text     "request",          limit: 65535
    t.integer  "modified_user_id", limit: 4,     null: false
    t.datetime "modified_date",                  null: false
  end

  add_index "projects_requests", ["modified_user_id"], name: "modified_user_id", using: :btree
  add_index "projects_requests", ["project_id"], name: "project_id", using: :btree

  create_table "projects_technologies", force: :cascade do |t|
    t.integer "project_id",    limit: 4, null: false
    t.integer "technology_id", limit: 4, null: false
  end

  add_index "projects_technologies", ["project_id"], name: "project_id", using: :btree
  add_index "projects_technologies", ["technology_id"], name: "technology_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.integer  "currency_id",      limit: 4,   null: false
    t.string   "title",            limit: 255, null: false
    t.integer  "modified_user_id", limit: 4,   null: false
    t.datetime "modified_date",                null: false
  end

  create_table "rates_prices", force: :cascade do |t|
    t.integer  "rate_id",             limit: 4,                          null: false
    t.integer  "engagement_model_id", limit: 4,                          null: false
    t.integer  "technology_id",       limit: 4,                          null: false
    t.integer  "position_id",         limit: 4,                          null: false
    t.decimal  "daily_rate",                    precision: 13, scale: 4, null: false
    t.decimal  "hourly_rate",                   precision: 13, scale: 4, null: false
    t.integer  "modified_user_id",    limit: 4,                          null: false
    t.datetime "modified_date",                                          null: false
  end

  add_index "rates_prices", ["modified_user_id"], name: "modified_user_id", using: :btree
  add_index "rates_prices", ["position_id"], name: "position_id", using: :btree
  add_index "rates_prices", ["technology_id"], name: "technology_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "title", limit: 255, null: false
  end

  create_table "technologies", force: :cascade do |t|
    t.string  "title",    limit: 255, null: false
    t.string  "style",    limit: 25
    t.boolean "is_rated", limit: 1,   null: false
  end

  add_index "technologies", ["title"], name: "title", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 150,             null: false
    t.string   "password_digest", limit: 255,             null: false
    t.string   "first_name",      limit: 150,             null: false
    t.string   "last_name",       limit: 150,             null: false
    t.string   "remember_token",  limit: 255,             null: false
    t.integer  "technology_id",   limit: 4,               null: false
    t.integer  "position_id",     limit: 4,               null: false
    t.integer  "client_id",       limit: 4,               null: false
    t.integer  "is_pdm",          limit: 1,   default: 0, null: false
    t.integer  "is_am",           limit: 1,   default: 0, null: false
    t.datetime "created_date",                            null: false
    t.datetime "last_modified",                           null: false
  end

  add_index "users", ["client_id"], name: "client_id", using: :btree
  add_index "users", ["position_id"], name: "position_id", using: :btree
  add_index "users", ["technology_id"], name: "technology_id", using: :btree
  add_index "users", ["username"], name: "username", unique: true, using: :btree

  create_table "users_permissions", force: :cascade do |t|
    t.integer "user_id",       limit: 4, null: false
    t.integer "permission_id", limit: 4, null: false
  end

  add_index "users_permissions", ["permission_id"], name: "permission_id", using: :btree
  add_index "users_permissions", ["user_id"], name: "user_id", using: :btree

  add_foreign_key "projects", "clients", name: "fk_projects_clients"
  add_foreign_key "projects", "project_statuses", name: "fk_projects_projects_statuses"
  add_foreign_key "projects", "users", column: "account_manager_user_id", name: "fk_projects_accountmanager"
end
