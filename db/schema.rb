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

ActiveRecord::Schema.define(version: 20140402144232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.decimal  "amount",                                    precision: 14, scale: 2, default: 0.0
    t.decimal  "initial_amount",                            precision: 14, scale: 2, default: 0.0
    t.integer  "last_update_transaction_activity_entry_id"
    t.boolean  "is_contra_account",                                                  default: false
    t.integer  "original_account_id"
    t.integer  "normal_balance",                                                     default: 1
    t.integer  "account_case",                                                       default: 2
    t.integer  "classification",                                                     default: 1
    t.boolean  "is_base_account",                                                    default: false
    t.boolean  "is_temporary_account",                                               default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", force: true do |t|
    t.integer  "calendar_id"
    t.integer  "customer_id"
    t.integer  "price_id"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer  "number_of_hours"
    t.datetime "actual_start_datetime"
    t.datetime "actual_end_datetime"
    t.boolean  "is_confirmed",                                    default: false
    t.datetime "confirmed_datetime"
    t.decimal  "discount",               precision: 5,  scale: 2, default: 0.0
    t.boolean  "is_started",                                      default: false
    t.boolean  "is_finished",                                     default: false
    t.boolean  "is_canceled",                                     default: false
    t.boolean  "is_deleted",                                      default: false
    t.boolean  "is_paid",                                         default: false
    t.datetime "paid_datetime"
    t.boolean  "is_salvaged",                                     default: false
    t.datetime "salvage_datetime"
    t.decimal  "amount",                 precision: 12, scale: 2, default: 0.0
    t.boolean  "is_downpayment_imposed",                          default: true
    t.string   "code"
    t.string   "booking_code"
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
    t.decimal  "amount",               precision: 11, scale: 2, default: 0.0
    t.integer  "case"
    t.datetime "transaction_datetime"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_details", force: true do |t|
    t.integer  "booking_id"
    t.integer  "price_rule_id"
    t.decimal  "amount",          precision: 9, scale: 2, default: 0.0
    t.integer  "number_of_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_rules", force: true do |t|
    t.integer  "hour_start"
    t.integer  "hour_end"
    t.boolean  "is_sunday",                               default: false
    t.boolean  "is_monday",                               default: false
    t.boolean  "is_tuesday",                              default: false
    t.boolean  "is_wednesday",                            default: false
    t.boolean  "is_thursday",                             default: false
    t.boolean  "is_friday",                               default: false
    t.boolean  "is_saturday",                             default: false
    t.decimal  "amount",         precision: 12, scale: 2, default: 0.0
    t.integer  "rule_case",                               default: 1
    t.integer  "calendar_id"
    t.boolean  "is_active",                               default: true
    t.datetime "deactivated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "holiday_date"
    t.boolean  "is_holiday",                              default: false
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

  create_table "salvage_bookings", force: true do |t|
    t.integer  "booking_id"
    t.datetime "salvaged_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_activities", force: true do |t|
    t.integer  "transaction_source_id"
    t.string   "transaction_source_type"
    t.datetime "transaction_datetime"
    t.text     "description"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_activity_entries", force: true do |t|
    t.integer  "transaction_activity_id"
    t.integer  "account_id"
    t.integer  "entry_case"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_bank_transaction",                              default: false
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
