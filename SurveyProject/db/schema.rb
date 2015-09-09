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

ActiveRecord::Schema.define(version: 20150909081722) do

  create_table "choices", force: true do |t|
    t.text     "content",     null: false
    t.integer  "question_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "name_client",       null: false
    t.string   "connection_string"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "employees", force: true do |t|
    t.integer "user_id", null: false
  end

  create_table "finish_surveys", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "survey_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leaders", force: true do |t|
    t.integer "user_id", null: false
  end

  create_table "priorities", force: true do |t|
    t.string "name_priority", null: false
  end

  create_table "questions", force: true do |t|
    t.text     "content",          null: false
    t.text     "link_picture"
    t.integer  "type_question_id", null: false
    t.integer  "survey_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "numero_question"
  end

  create_table "responses", force: true do |t|
    t.integer  "question_id", null: false
    t.integer  "choice_id",   null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "name_survey",                   null: false
    t.integer  "type_survey_id",                null: false
    t.integer  "priority_id",                   null: false
    t.integer  "user_id",                       null: false
    t.datetime "date_closed",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "status",         default: true
  end

  create_table "sysdiagrams", primary_key: "diagram_id", force: true do |t|
    t.string  "name",         limit: 128, null: false
    t.integer "principal_id",             null: false
    t.integer "version"
    t.binary  "definition"
  end

  add_index "sysdiagrams", ["principal_id", "name"], name: "UK_principal_name", unique: true

  create_table "type_questions", force: true do |t|
    t.string   "name_type_question", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code_type_question", null: false
  end

  create_table "type_surveys", force: true do |t|
    t.string "name_type_survey", null: false
  end

  create_table "users", force: true do |t|
    t.string   "firstname",       null: false
    t.string   "lastname",        null: false
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.string   "link_picture"
    t.string   "permission",      null: false
    t.integer  "clients_id",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
