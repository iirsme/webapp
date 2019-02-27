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

ActiveRecord::Schema.define(version: 2019_02_27_195230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "audits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "record_id", null: false
    t.string "entity", null: false
    t.string "action", null: false
    t.uuid "user_id", null: false
    t.datetime "done_at", null: false
    t.jsonb "log", default: "{}", null: false
    t.index ["record_id"], name: "index_audits_on_record_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "candidates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "seq_no", default: -> { "nextval('candidate_seq'::regclass)" }
    t.string "curp", null: false
    t.string "name", null: false
    t.string "last_name1", null: false
    t.string "last_name2"
    t.date "birth_date"
    t.date "evaluation_date"
    t.integer "age"
    t.string "phone"
    t.string "cell_phone"
    t.string "email"
    t.string "gender"
    t.string "marital_status"
    t.string "occupation"
    t.string "occupation_other"
    t.string "scolarship"
    t.string "birth_city"
    t.string "birth_state"
    t.string "birth_country"
    t.string "address_main_street"
    t.string "address_street_no1"
    t.string "address_street_no2"
    t.string "address_street1"
    t.string "address_street2"
    t.string "address_region"
    t.string "address_city"
    t.string "address_state"
    t.string "address_country"
    t.string "diagnosis"
    t.date "diagnosis_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.string "field_type", null: false
    t.jsonb "values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validation_type"
    t.text "description"
  end

  create_table "geonames", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "geoname_id", null: false
    t.string "name", null: false
    t.index ["geoname_id"], name: "index_geonames_on_geoname_id"
  end

  create_table "research_fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "research_id", null: false
    t.uuid "tab_id", null: false
    t.uuid "field_id", null: false
    t.boolean "is_required", default: false, null: false
    t.decimal "seq_no", null: false
    t.index ["field_id"], name: "index_research_fields_on_field_id"
    t.index ["research_id"], name: "index_research_fields_on_research_id"
    t.index ["tab_id"], name: "index_research_fields_on_tab_id"
  end

  create_table "research_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "research_id", null: false
    t.uuid "role_id", null: false
    t.boolean "is_owner", default: false, null: false
    t.index ["research_id"], name: "index_research_users_on_research_id"
    t.index ["role_id"], name: "index_research_users_on_role_id"
    t.index ["user_id", "research_id"], name: "index_research_users_on_user_id_and_research_id", unique: true
    t.index ["user_id"], name: "index_research_users_on_user_id"
  end

  create_table "researches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.text "description"
    t.boolean "is_private", default: false
    t.string "password"
    t.decimal "seq_no", default: -> { "nextval('research_seq'::regclass)" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "registration_code"
    t.uuid "owner_id"
    t.index ["owner_id"], name: "index_researches_on_owner_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "can_create", default: false, null: false
    t.boolean "can_read", default: true, null: false
    t.boolean "can_update", default: false, null: false
    t.boolean "can_delete", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_audit", default: false
    t.boolean "is_default", default: false, null: false
  end

  create_table "tabs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "research_id", null: false
    t.decimal "seq_no"
    t.index ["name", "research_id"], name: "index_tabs_on_name_and_research_id", unique: true
    t.index ["research_id"], name: "index_tabs_on_research_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "password_digest", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "audits", "users"
  add_foreign_key "research_fields", "fields"
  add_foreign_key "research_fields", "researches"
  add_foreign_key "research_fields", "tabs"
  add_foreign_key "research_users", "researches"
  add_foreign_key "research_users", "roles"
  add_foreign_key "research_users", "users"
  add_foreign_key "researches", "users", column: "owner_id"
  add_foreign_key "tabs", "researches"
end
