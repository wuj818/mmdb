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

ActiveRecord::Schema.define(version: 2019_02_25_070656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "counters", force: :cascade do |t|
    t.bigint "countable_id"
    t.text "countable_type"
    t.bigint "directing_credits_count", default: 0
    t.bigint "writing_credits_count", default: 0
    t.bigint "composing_credits_count", default: 0
    t.bigint "editing_credits_count", default: 0
    t.bigint "cinematography_credits_count", default: 0
    t.bigint "acting_credits_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["countable_id", "countable_type"], name: "index_counters_on_countable_id_and_countable_type", unique: true
  end

  create_table "credits", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "movie_id"
    t.text "job"
    t.text "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["movie_id"], name: "idx_35381_index_credits_on_movie_id"
    t.index ["person_id"], name: "idx_35381_index_credits_on_person_id"
  end

  create_table "movies", id: :bigint, default: nil, force: :cascade do |t|
    t.text "title"
    t.text "imdb_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "year"
    t.bigint "rating", default: 5
    t.bigint "runtime", default: 0
    t.text "permalink"
    t.text "sort_title"
    t.text "aka"
    t.text "rotten_tomatoes_url"
    t.text "synopsis"
    t.bigint "credits_count", default: 0
    t.text "poster_file_name"
    t.text "poster_url"
    t.text "poster_content_type"
    t.bigint "poster_file_size"
    t.datetime "poster_updated_at"
    t.text "movie_poster_db_url"
    t.text "cached_country_list"
    t.text "cached_genre_list"
    t.text "cached_language_list"
    t.index ["permalink"], name: "idx_35419_index_movies_on_permalink"
    t.index ["sort_title"], name: "idx_35419_index_movies_on_sort_title"
  end

  create_table "people", force: :cascade do |t|
    t.text "name"
    t.text "imdb_url"
    t.text "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "credits_count", default: 0
    t.text "sort_name"
    t.index ["permalink"], name: "idx_35405_index_people_on_permalink"
    t.index ["sort_name"], name: "idx_35405_index_people_on_sort_name"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.text "taggable_type"
    t.bigint "tagger_id"
    t.text "tagger_type"
    t.text "context"
    t.datetime "created_at"
    t.index ["context"], name: "idx_35372_index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "idx_35372_taggings_idx", unique: true
    t.index ["tag_id"], name: "idx_35372_index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "idx_35372_index_taggings_on_taggable_id_and_taggable_type_and_c"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "idx_35372_taggings_idy"
    t.index ["taggable_id"], name: "idx_35372_index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "idx_35372_index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "idx_35372_index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "idx_35372_index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.text "name"
    t.bigint "taggings_count", default: 0
    t.index ["name"], name: "idx_35362_index_tags_on_name", unique: true
  end

end
