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

ActiveRecord::Schema.define(:version => 15) do

  create_table "counters", :force => true do |t|
    t.integer  "countable_id"
    t.string   "countable_type"
    t.integer  "directing_credits_count",      :default => 0
    t.integer  "writing_credits_count",        :default => 0
    t.integer  "composing_credits_count",      :default => 0
    t.integer  "editing_credits_count",        :default => 0
    t.integer  "cinematography_credits_count", :default => 0
    t.integer  "acting_credits_count",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counters", ["countable_id", "countable_type"], :name => "index_counters_on_countable_id_and_countable_type"

  create_table "credits", :force => true do |t|
    t.integer  "person_id"
    t.integer  "movie_id"
    t.string   "job"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["movie_id"], :name => "index_credits_on_movie_id"
  add_index "credits", ["person_id"], :name => "index_credits_on_person_id"

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.string   "imdb_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.integer  "rating",              :default => 0
    t.integer  "runtime",             :default => 0
    t.string   "permalink"
    t.string   "sort_title"
    t.string   "aka"
    t.string   "rotten_tomatoes_url"
    t.text     "synopsis"
    t.integer  "credits_count",       :default => 0
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "imdb_url"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credits_count", :default => 0
    t.string   "sort_name"
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

end
