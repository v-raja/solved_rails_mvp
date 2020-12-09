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

ActiveRecord::Schema.define(version: 2020_12_09_074846) do

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

  create_table "galleries", force: :cascade do |t|
    t.string "thumbnail_url"
    t.integer "post_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_galleries_on_post_id"
  end

  create_table "media_urls", force: :cascade do |t|
    t.text "url"
    t.integer "gallery_position"
    t.integer "gallery_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gallery_id", "gallery_position"], name: "index_media_urls_on_gallery_id_and_gallery_position"
    t.index ["gallery_id"], name: "index_media_urls_on_gallery_id"
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
    t.index ["code"], name: "index_niches_on_code", unique: true
    t.index ["slug"], name: "index_niches_on_slug", unique: true
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
    t.text "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "galleries", "posts"
  add_foreign_key "media_urls", "galleries"
  add_foreign_key "posts", "products"
end
