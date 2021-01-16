# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_15_084132) do

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.string "title"
    t.text "body"
    t.string "subject"
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "industries", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "code"
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "industry_category_id", null: false
    t.index ["industry_category_id"], name: "index_industries_on_industry_category_id"
    t.index ["slug"], name: "index_industries_on_slug", unique: true
  end

  create_table "industry_categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "code", null: false
    t.string "slug", null: false
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_industry_categories_on_ancestry"
    t.index ["slug", "type"], name: "index_industry_categories_on_slug_and_type", unique: true
  end

  create_table "industry_posts", force: :cascade do |t|
    t.integer "post_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["industry_id"], name: "index_industry_posts_on_industry_id"
    t.index ["post_id", "industry_id"], name: "index_industry_posts_on_post_id_and_industry_id", unique: true
    t.index ["post_id"], name: "index_industry_posts_on_post_id"
  end

  create_table "industry_requests", force: :cascade do |t|
    t.integer "request_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["industry_id"], name: "index_industry_requests_on_industry_id"
    t.index ["request_id", "industry_id"], name: "index_industry_requests_on_request_id_and_industry_id", unique: true
    t.index ["request_id"], name: "index_industry_requests_on_request_id"
  end

  create_table "niche_posts", force: :cascade do |t|
    t.integer "post_id"
    t.integer "niche_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["niche_id"], name: "index_niche_posts_on_niche_id"
    t.index ["post_id", "niche_id"], name: "index_niche_posts_on_post_id_and_niche_id", unique: true
    t.index ["post_id"], name: "index_niche_posts_on_post_id"
  end

  create_table "niches", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "code", null: false
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.index ["code"], name: "index_niches_on_code", unique: true
    t.index ["slug"], name: "index_niches_on_slug", unique: true
  end

  create_table "occupation_categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "illustrative_examples"
    t.text "other_examples"
    t.string "code", null: false
    t.string "slug", null: false
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_occupation_categories_on_ancestry"
    t.index ["slug", "type"], name: "index_occupation_categories_on_slug_and_type", unique: true
  end

  create_table "occupation_posts", force: :cascade do |t|
    t.integer "post_id"
    t.integer "occupation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["occupation_id"], name: "index_occupation_posts_on_occupation_id"
    t.index ["post_id", "occupation_id"], name: "index_occupation_posts_on_post_id_and_occupation_id", unique: true
    t.index ["post_id"], name: "index_occupation_posts_on_post_id"
  end

  create_table "occupation_requests", force: :cascade do |t|
    t.integer "request_id"
    t.integer "occupation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["occupation_id"], name: "index_occupation_requests_on_occupation_id"
    t.index ["request_id", "occupation_id"], name: "index_occupation_requests_on_request_id_and_occupation_id", unique: true
    t.index ["request_id"], name: "index_occupation_requests_on_request_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "code", null: false
    t.text "illustrative_examples"
    t.text "other_examples"
    t.string "slug", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "occupation_category_id", null: false
    t.index ["code"], name: "index_occupations_on_code", unique: true
    t.index ["occupation_category_id"], name: "index_occupations_on_occupation_category_id"
    t.index ["slug"], name: "index_occupations_on_slug", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "problem_title"
    t.string "tagline"
    t.text "description"
    t.string "product_url"
    t.integer "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.index ["product_id"], name: "index_posts_on_product_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "logo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "pseudonym"
    t.string "role"
    t.string "company"
    t.string "fake_company"
    t.boolean "admin", default: false
    t.text "thumbnail_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  create_table "youtube_urls", force: :cascade do |t|
    t.text "url"
    t.integer "post_id", null: false
    t.string "youtube_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_youtube_urls_on_post_id"
  end

  add_foreign_key "industries", "industry_categories"
  add_foreign_key "occupations", "occupation_categories"
  add_foreign_key "posts", "products"
  add_foreign_key "posts", "users"
  add_foreign_key "requests", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "youtube_urls", "posts"
end
