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

ActiveRecord::Schema.define(version: 2021_02_13_021526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer "commentable_id"
    t.text "commentable_type"
    t.text "title"
    t.text "body"
    t.text "body_safe_html"
    t.text "subject"
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "discarded_at"
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["discarded_at"], name: "index_comments_on_discarded_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "description"
    t.text "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_happy_user", default: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followable_type", null: false
    t.bigint "followable_id", null: false
    t.string "follower_type", null: false
    t.bigint "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
    t.index ["follower_type", "follower_id"], name: "index_follows_on_follower_type_and_follower_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.text "slug", null: false
    t.integer "sluggable_id", null: false
    t.text "sluggable_type"
    t.text "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "group_solutions", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "solution_id", null: false
    t.integer "solution_votes", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_solutions_on_group_id"
    t.index ["solution_id", "group_id"], name: "index_group_solutions_on_solution_id_and_group_id", unique: true
    t.index ["solution_id"], name: "index_group_solutions_on_solution_id"
  end

  create_table "groups", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "slug"
    t.text "keywords"
    t.integer "solutions_count", default: 0, null: false
    t.integer "solution_votes_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_groups_on_slug", unique: true
    t.index ["title"], name: "index_groups_on_title", unique: true
  end

  create_table "industries", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "code"
    t.text "slug"
    t.text "keywords"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "industry_category_id", null: false
    t.integer "solutions_count", default: 0, null: false
    t.integer "requests_count", default: 0, null: false
    t.integer "solution_votes_count", default: 0, null: false
    t.boolean "is_unlocked", default: false
    t.text "user_suggested_keywords"
    t.boolean "is_postable", default: false
    t.index ["code"], name: "index_industries_on_code", unique: true
    t.index ["industry_category_id"], name: "index_industries_on_industry_category_id"
    t.index ["slug"], name: "index_industries_on_slug", unique: true
  end

  create_table "industry_categories", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "code"
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_industry_categories_on_ancestry"
    t.index ["code"], name: "index_industry_categories_on_code", unique: true
    t.index ["slug"], name: "index_industry_categories_on_slug", unique: true
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

  create_table "industry_solutions", force: :cascade do |t|
    t.integer "solution_id"
    t.integer "industry_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "solution_votes", default: 0, null: false
    t.index ["industry_id"], name: "index_industry_solutions_on_industry_id"
    t.index ["solution_id", "industry_id"], name: "index_industry_solutions_on_solution_id_and_industry_id", unique: true
    t.index ["solution_id"], name: "index_industry_solutions_on_solution_id"
  end

  create_table "login_activities", force: :cascade do |t|
    t.string "scope"
    t.string "strategy"
    t.string "identity"
    t.boolean "success"
    t.string "failure_reason"
    t.string "user_type"
    t.bigint "user_id"
    t.string "context"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "city"
    t.string "region"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.index ["identity"], name: "index_login_activities_on_identity"
    t.index ["ip"], name: "index_login_activities_on_ip"
    t.index ["user_type", "user_id"], name: "index_login_activities_on_user_type_and_user_id"
  end

  create_table "mini_requests", force: :cascade do |t|
    t.text "description"
    t.text "email"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mini_requests_on_user_id"
  end

  create_table "notable_jobs", force: :cascade do |t|
    t.string "note_type"
    t.text "note"
    t.text "job"
    t.string "job_id"
    t.string "queue"
    t.float "runtime"
    t.float "queued_time"
    t.datetime "created_at"
  end

  create_table "notable_requests", force: :cascade do |t|
    t.string "note_type"
    t.text "note"
    t.string "user_type"
    t.bigint "user_id"
    t.text "action"
    t.integer "status"
    t.text "url"
    t.string "request_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "params"
    t.float "request_time"
    t.datetime "created_at"
    t.index ["user_type", "user_id"], name: "index_notable_requests_on_user_type_and_user_id"
  end

  create_table "occupation_categories", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "code"
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0
    t.index ["ancestry"], name: "index_occupation_categories_on_ancestry"
    t.index ["code"], name: "index_occupation_categories_on_code", unique: true
    t.index ["slug"], name: "index_occupation_categories_on_slug", unique: true
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

  create_table "occupation_solutions", force: :cascade do |t|
    t.integer "solution_id"
    t.integer "occupation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "solution_votes", default: 0, null: false
    t.index ["occupation_id"], name: "index_occupation_solutions_on_occupation_id"
    t.index ["solution_id", "occupation_id"], name: "index_occupation_solutions_on_solution_id_and_occupation_id", unique: true
    t.index ["solution_id"], name: "index_occupation_solutions_on_solution_id"
  end

  create_table "occupations", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "code"
    t.text "slug"
    t.text "keywords"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "occupation_category_id", null: false
    t.integer "solutions_count", default: 0, null: false
    t.integer "requests_count", default: 0, null: false
    t.integer "solution_votes_count", default: 0, null: false
    t.boolean "is_unlocked", default: false
    t.text "user_suggested_keywords"
    t.boolean "is_postable", default: false
    t.index ["code"], name: "index_occupations_on_code", unique: true
    t.index ["occupation_category_id"], name: "index_occupations_on_occupation_category_id"
    t.index ["slug"], name: "index_occupations_on_slug", unique: true
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "plans", force: :cascade do |t|
    t.text "name"
    t.boolean "is_price_per_user", default: false
    t.decimal "price_per_month", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id", null: false
    t.boolean "is_for_education", default: false
    t.index ["product_id"], name: "index_plans_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "name"
    t.text "thumbnail_url"
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "description_safe_html"
    t.bigint "user_id", null: false
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.integer "comments_count", default: 0, null: false
    t.index ["slug"], name: "index_requests_on_slug", unique: true
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "description_safe_html"
    t.text "get_it_url"
    t.bigint "product_id", null: false
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.boolean "is_creator", default: false
    t.integer "comments_count", default: 0, null: false
    t.bigint "plan_id"
    t.text "demoer_name"
    t.boolean "front_page", default: true
    t.index ["plan_id"], name: "index_solutions_on_plan_id"
    t.index ["product_id"], name: "index_solutions_on_product_id"
    t.index ["slug"], name: "index_solutions_on_slug", unique: true
    t.index ["user_id"], name: "index_solutions_on_user_id"
  end

  create_table "suggested_communities", force: :cascade do |t|
    t.integer "user_id"
    t.text "community"
    t.text "community_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["community"], name: "index_suggested_communities_on_community"
  end

  create_table "suggested_keywords", force: :cascade do |t|
    t.text "industry_slug"
    t.text "occupation_slug"
    t.text "keyword"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "group_slug"
    t.index ["group_slug"], name: "index_suggested_keywords_on_group_slug"
    t.index ["industry_slug"], name: "index_suggested_keywords_on_industry_slug"
    t.index ["keyword"], name: "index_suggested_keywords_on_keyword"
    t.index ["occupation_slug"], name: "index_suggested_keywords_on_occupation_slug"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.text "context"
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

  create_table "tags", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text "current_sign_in_ip"
    t.text "last_sign_in_ip"
    t.text "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text "unconfirmed_email"
    t.text "name"
    t.text "bio"
    t.boolean "admin", default: false
    t.text "thumbnail_url"
    t.text "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.text "vote_scope"
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
    t.bigint "solution_id", null: false
    t.text "youtube_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["solution_id"], name: "index_youtube_urls_on_solution_id"
  end

  add_foreign_key "feedbacks", "users"
  add_foreign_key "group_solutions", "groups"
  add_foreign_key "group_solutions", "solutions"
  add_foreign_key "industries", "industry_categories"
  add_foreign_key "mini_requests", "users"
  add_foreign_key "occupations", "occupation_categories"
  add_foreign_key "plans", "products"
  add_foreign_key "requests", "users"
  add_foreign_key "solutions", "plans"
  add_foreign_key "solutions", "products"
  add_foreign_key "solutions", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "youtube_urls", "solutions"
end
