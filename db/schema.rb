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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111110031023) do

  create_table "competitions", :force => true do |t|
    t.integer  "user_id"
    t.string   "host"
    t.string   "title"
    t.text     "intro"
    t.text     "description"
    t.text     "prizes"
    t.text     "about"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tracks_count", :default => 0
    t.string   "rules"
    t.string   "download"
    t.integer  "group"
    t.boolean  "recording",    :default => false
  end

  create_table "tracks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tid"
    t.string   "title"
    t.string   "permalink"
    t.string   "artwork_url"
    t.string   "waveform_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secret_token"
    t.integer  "competition_id"
  end

  create_table "users", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "username"
    t.string   "permalink"
    t.string   "avatar_url"
    t.string   "city"
    t.string   "country"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
