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

ActiveRecord::Schema.define(:version => 10) do

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
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "imdb_url"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
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
