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

ActiveRecord::Schema.define(version: 20160723131122) do

  create_table "cas", force: :cascade do |t|
    t.string   "country",           null: false
    t.string   "organization"
    t.string   "organization_unit"
    t.string   "common_name",       null: false
    t.string   "state"
    t.string   "locality"
    t.integer  "serial",            null: false
    t.datetime "not_before",        null: false
    t.datetime "not_after",         null: false
    t.text     "private_key",       null: false
    t.text     "certificate",       null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "certificates", force: :cascade do |t|
    t.string   "country",           null: false
    t.string   "organization"
    t.string   "organization_unit"
    t.string   "common_name",       null: false
    t.string   "state"
    t.string   "locality"
    t.integer  "serial",            null: false
    t.datetime "not_before",        null: false
    t.datetime "not_after",         null: false
    t.text     "private_key"
    t.text     "certificate",       null: false
    t.integer  "ca_id",             null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
