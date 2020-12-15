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

ActiveRecord::Schema.define(version: 2020_12_15_104842) do

  create_table "commontator_comments", force: :cascade do |t|
    t.integer "thread_id", null: false
    t.string "creator_type", null: false
    t.integer "creator_id", null: false
    t.string "editor_type"
    t.integer "editor_id"
    t.text "body", null: false
    t.datetime "deleted_at"
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "parent_id"
    t.index ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down"
    t.index ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up"
    t.index ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id"
    t.index ["editor_type", "editor_id"], name: "index_commontator_comments_on_editor_type_and_editor_id"
    t.index ["parent_id"], name: "index_commontator_comments_on_parent_id"
    t.index ["thread_id", "created_at"], name: "index_commontator_comments_on_thread_id_and_created_at"
  end

  create_table "commontator_subscriptions", force: :cascade do |t|
    t.integer "thread_id", null: false
    t.string "subscriber_type", null: false
    t.integer "subscriber_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true
    t.index ["thread_id"], name: "index_commontator_subscriptions_on_thread_id"
  end

  create_table "commontator_threads", force: :cascade do |t|
    t.string "commontable_type"
    t.integer "commontable_id"
    t.string "closer_type"
    t.integer "closer_id"
    t.datetime "closed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["closer_type", "closer_id"], name: "index_commontator_threads_on_closer_type_and_closer_id"
    t.index ["commontable_type", "commontable_id"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true
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
    t.index ["product_id"], name: "index_posts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "logo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "pseudonym"
    t.string "role"
    t.string "company"
    t.string "fake_company"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "youtube_urls", force: :cascade do |t|
    t.text "url"
    t.integer "post_id", null: false
    t.string "youtube_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_youtube_urls_on_post_id"
  end

  add_foreign_key "commontator_comments", "commontator_comments", column: "parent_id", on_update: :restrict, on_delete: :cascade
  add_foreign_key "commontator_comments", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "commontator_subscriptions", "commontator_threads", column: "thread_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "industries", "industry_categories"
  add_foreign_key "occupations", "occupation_categories"
  add_foreign_key "posts", "products"
  add_foreign_key "youtube_urls", "posts"
end
