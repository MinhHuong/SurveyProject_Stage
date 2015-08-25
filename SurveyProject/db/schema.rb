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

ActiveRecord::Schema.define(version: 20150825031542) do

  create_table "clients", force: true do |t|
    t.string "name_client",       null: false
    t.string "connection_string"
    t.date   "date_join"
  end

  create_table "employees", force: true do |t|
    t.integer "user_id", null: false
  end

  create_table "leaders", force: true do |t|
    t.integer "user_id", null: false
  end

  create_table "sysdiagrams", primary_key: "diagram_id", force: true do |t|
    t.string  "name",         limit: 128, null: false
    t.integer "principal_id",             null: false
    t.integer "version"
    t.binary  "definition"
  end

  add_index "sysdiagrams", ["principal_id", "name"], name: "UK_principal_name", unique: true

  create_table "users", force: true do |t|
    t.string  "firstname",       null: false
    t.string  "lastname",        null: false
    t.string  "username",        null: false
    t.string  "password_digest", null: false
    t.string  "link_picture"
    t.date    "date_create"
    t.integer "clients_id",      null: false
  end

end
