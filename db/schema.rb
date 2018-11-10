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

ActiveRecord::Schema.define(version: 2018_11_10_041514) do

  create_table "counters", force: :cascade do |t|
    t.integer "countable_id"
    t.string "countable_type", limit: 255
    t.integer "directing_credits_count", default: 0
    t.integer "writing_credits_count", default: 0
    t.integer "composing_credits_count", default: 0
    t.integer "editing_credits_count", default: 0
    t.integer "cinematography_credits_count", default: 0
    t.integer "acting_credits_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["countable_id", "countable_type"], name: "index_counters_on_countable_id_and_countable_type"
  end

  create_table "credits", force: :cascade do |t|
    t.integer "person_id"
    t.integer "movie_id"
    t.string "job", limit: 255
    t.string "details", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["movie_id"], name: "index_credits_on_movie_id"
    t.index ["person_id"], name: "index_credits_on_person_id"
  end

  create_table "item_lists", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "permalink", limit: 255
    t.integer "position", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["permalink"], name: "index_item_lists_on_permalink"
  end

  create_table "listings", force: :cascade do |t|
    t.integer "item_list_id"
    t.integer "movie_id"
    t.integer "position", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "imdb_url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "year"
    t.integer "rating", default: 0
    t.integer "runtime", default: 0
    t.string "permalink", limit: 255
    t.string "sort_title", limit: 255
    t.string "aka", limit: 255
    t.string "rotten_tomatoes_url", limit: 255
    t.text "synopsis"
    t.integer "credits_count", default: 0
    t.string "poster_file_name", limit: 255
    t.string "poster_url", limit: 255
    t.string "poster_content_type", limit: 255
    t.integer "poster_file_size"
    t.datetime "poster_updated_at"
    t.string "movie_poster_db_url", limit: 255
    t.index ["permalink"], name: "index_movies_on_permalink"
    t.index ["sort_title"], name: "index_movies_on_sort_title"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "imdb_url", limit: 255
    t.string "permalink", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "credits_count", default: 0
    t.string "sort_name", limit: 255
    t.index ["permalink"], name: "index_people_on_permalink"
    t.index ["sort_name"], name: "index_people_on_sort_name"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "context", limit: 255
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

end
