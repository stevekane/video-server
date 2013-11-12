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

ActiveRecord::Schema.define(version: 20131107022451) do

  create_table "stripe_events", force: true do |t|
    t.string   "event_id"
    t.datetime "created"
    t.boolean  "livemode"
    t.string   "event_type"
    t.text     "data"
    t.boolean  "processed",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
    t.string   "object"
    t.integer  "pending_webhooks"
    t.string   "request"
    t.text     "stripe_webhook"
  end

  add_index "stripe_events", ["event_id"], name: "index_stripe_events_on_event_id"
  add_index "stripe_events", ["subscription_id"], name: "index_stripe_events_on_subscription_id"

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_id"
    t.string   "credit_card_last_four"
    t.date     "credit_card_expiration_date"
    t.datetime "next_bill_date"
    t.integer  "next_bill_amount"
    t.string   "state",                       default: "inactive"
  end

  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id"
  add_index "subscriptions", ["state"], name: "index_subscriptions_on_state"
  add_index "subscriptions", ["stripe_id"], name: "index_subscriptions_on_stripe_id"
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_token"
    t.integer  "github_uid"
    t.string   "github_nickname"
    t.string   "github_image"
    t.string   "state"
    t.datetime "checked_in_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "full_name"
    t.string   "twitter"
    t.string   "blog"
    t.text     "about"
    t.string   "phone"
    t.string   "birthday"
    t.string   "current_status"
    t.text     "skills"
    t.string   "authentication_token"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"

end
