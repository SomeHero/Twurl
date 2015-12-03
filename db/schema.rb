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

ActiveRecord::Schema.define(version: 20150827185011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "channels", ["category_id"], name: "index_channels_on_category_id", using: :btree

  create_table "feeds", force: true do |t|
    t.string   "feed_name"
    t.integer  "user_id"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["user_id"], name: "index_feeds_on_user_id", using: :btree

  create_table "feeds_twurls", id: false, force: true do |t|
    t.integer "feed_id",       null: false
    t.integer "twurl_link_id", null: false
  end

  create_table "influencer_event_daily_summaries", force: true do |t|
    t.integer  "influencer_id"
    t.string   "influencer_event_name"
    t.integer  "count"
    t.date     "event_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "influencer_event_daily_summaries", ["influencer_id"], name: "index_influencer_event_daily_summaries_on_influencer_id", using: :btree

  create_table "parse_twurls_batch_audits", force: true do |t|
    t.integer  "twurls_created"
    t.integer  "twurls_errors"
    t.integer  "first_influencer_parsed_id"
    t.integer  "last_influencer_parsed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slack_channels", force: true do |t|
    t.integer  "slack_team_id"
    t.string   "channel_name"
    t.string   "webhook_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slack_channels", ["slack_team_id"], name: "index_slack_channels_on_slack_team_id", using: :btree

  create_table "slack_teams", force: true do |t|
    t.integer  "user_id"
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slack_teams", ["user_id"], name: "index_slack_teams_on_user_id", using: :btree

  create_table "sources", force: true do |t|
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitter_username"
    t.integer  "channel_id"
    t.string   "profile_image_url"
    t.boolean  "is_influencer",     default: false
  end

  create_table "twurl_event_daily_summaries", force: true do |t|
    t.integer  "twurl_link_id"
    t.string   "twurl_event_name"
    t.integer  "count"
    t.date     "event_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twurl_event_daily_summaries", ["twurl_link_id"], name: "index_twurl_event_daily_summaries_on_twurl_link_id", using: :btree

  create_table "twurl_events", force: true do |t|
    t.integer  "twurl_link_id"
    t.string   "twurl_event_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twurl_events", ["twurl_link_id"], name: "index_twurl_events_on_twurl_link_id", using: :btree

  create_table "twurls", force: true do |t|
    t.integer  "source_id"
    t.string   "headline_image_url"
    t.string   "headline"
    t.string   "description"
    t.string   "url"
    t.integer  "share_count"
    t.integer  "like_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twitter_id",            limit: 8
    t.integer  "headline_image_height"
    t.integer  "headline_image_width"
    t.string   "original_tweet"
    t.boolean  "display",                         default: true
  end

  add_index "twurls", ["display"], name: "index_twurls_on_display", using: :btree
  add_index "twurls", ["source_id"], name: "index_twurls_on_source_id", using: :btree

  create_table "url_exceptions", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_muted_sources", force: true do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_muted_sources", ["source_id"], name: "index_user_muted_sources_on_source_id", using: :btree
  add_index "user_muted_sources", ["user_id"], name: "index_user_muted_sources_on_user_id", using: :btree

  create_table "user_reading_lists", force: true do |t|
    t.integer  "user_id"
    t.integer  "twurl_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_reading_lists", ["twurl_link_id"], name: "index_user_reading_lists_on_twurl_link_id", using: :btree
  add_index "user_reading_lists", ["user_id"], name: "index_user_reading_lists_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "twitter_id"
    t.string   "twitter_username"
    t.string   "twitter_auth_token"
    t.string   "twitter_secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
