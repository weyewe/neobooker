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

ActiveRecord::Schema.define(version: 20130813025057) do

  create_table "bookings", force: true do |t|
    t.string   "title"
    t.integer  "calendar_id"
    t.integer  "customer_id"
    t.integer  "price_id"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer  "number_of_hours"
    t.integer  "duration"
    t.datetime "actual_start_datetime"
    t.datetime "actual_end_datetime"
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmation_datetime"
    t.decimal  "discount",              precision: 5,  scale: 2, default: 0.0
    t.boolean  "is_started",                                     default: false
    t.boolean  "is_finished",                                    default: false
    t.boolean  "is_canceled",                                    default: false
    t.boolean  "is_deleted",                                     default: false
    t.decimal  "received_amount",       precision: 12, scale: 2, default: 0.0
    t.boolean  "is_paid",                                        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendars", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "color"
    t.decimal  "amount",                 precision: 9, scale: 2, default: 0.0
    t.decimal  "downpayment_percentage", precision: 5, scale: 2, default: 0.0
    t.boolean  "is_deleted",                                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "bb_pin"
    t.string   "mobile_phone"
    t.string   "contact"
    t.boolean  "is_deleted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "incomes", force: true do |t|
    t.integer  "income_source_id"
    t.string   "income_source_type"
    t.decimal  "amount",             precision: 11, scale: 2, default: 0.0
    t.integer  "case"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prices", force: true do |t|
    t.integer  "calendar_id"
    t.decimal  "amount",      precision: 9, scale: 2, default: 0.0
    t.boolean  "is_active",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.text     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "name"
    t.string   "username"
    t.string   "login"
    t.boolean  "is_deleted",             default: false
    t.boolean  "is_main_user",           default: false
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
