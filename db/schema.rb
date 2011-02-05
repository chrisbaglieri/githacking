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

ActiveRecord::Schema.define(:version => 20110204232220) do

  create_table "repositories", :force => true do |t|
    t.string   "project_name",                     :null => false
    t.string   "user",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "meta_data"
    t.string   "name"
    t.string   "owner"
    t.string   "description"
    t.datetime "pushed_at"
    t.string   "url",                              :null => false
    t.boolean  "private",       :default => false
    t.boolean  "has_wiki",      :default => false
    t.string   "homepage",      :default => "f"
    t.integer  "watchers",      :default => 0,     :null => false
    t.integer  "forks",         :default => 0,     :null => false
    t.boolean  "fork",          :default => false, :null => false
    t.integer  "open_issues",   :default => 0,     :null => false
    t.boolean  "has_issues",    :default => false, :null => false
    t.boolean  "has_downloads", :default => false, :null => false
    t.string   "source",                           :null => false
    t.string   "parent",                           :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_access_token",                :null => false
    t.string   "email"
  end

end
