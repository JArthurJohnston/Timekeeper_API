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

ActiveRecord::Schema.define(version: 20150823014228) do

  create_table "activities", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "timesheet_id"
    t.integer  "story_card_id"
    t.integer  "user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string  "name",                 limit: 255
    t.integer "statement_of_work_id"
  end

  create_table "statements_of_work", force: :cascade do |t|
    t.string  "number",                limit: 255
    t.string  "purchase_order_number", limit: 255
    t.string  "client",                limit: 255
    t.string  "nickname",              limit: 255
    t.integer "user_id"
  end

  create_table "story_cards", force: :cascade do |t|
    t.integer "project_id",  limit: 255
    t.string  "number",      limit: 255
    t.string  "title",       limit: 255
    t.string  "description", limit: 255
    t.integer "estimate"
  end

  create_table "timesheets", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "through_date"
    t.integer  "user_id"
    t.integer  "current_activity_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255
  end

end
