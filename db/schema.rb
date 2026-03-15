# frozen_string_literal: true

# This file is auto-generated from the current state of the database.
# Run: bin/rails db:schema:load to load this schema.
#
# Performance Lab schema: Users, Posts, Comments, Orders, Payments, Invoices

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000001) do
  enable_extension "pg_stat_statements" if ENV["PG_STAT_STATEMENTS"] == "1"
  # Note: pg_stat_statements is usually enabled via shared_preload_libraries in PostgreSQL config

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "metadata", default: {}
  end

  # Index for N+1 / missing index examples (email lookup)
  add_index "users", ["email"], name: "idx_users_email", using: :btree
  add_index "users", ["active"], name: "idx_users_active", using: :btree
  add_index "users", ["created_at"], name: "idx_users_created_at", using: :btree
  # Partial index: active users only (advanced example)
  add_index "users", ["email"], name: "idx_users_active_email", where: "active = true", using: :btree
  # GIN index for JSONB (advanced)
  add_index "users", ["metadata"], name: "idx_users_metadata_gin", using: :gin

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "body"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0, null: false
  end

  add_index "posts", ["user_id"], name: "idx_posts_user_id", using: :btree
  add_index "posts", ["published_at"], name: "idx_posts_published_at", using: :btree
  add_index "posts", ["created_at"], name: "idx_posts_created_at", using: :btree
  # Covering index (user_id + created_at) for keyset pagination
  add_index "posts", ["user_id", "created_at"], name: "idx_posts_user_created", using: :btree

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false, null: false
  end

  add_index "comments", ["post_id"], name: "idx_comments_post_id", using: :btree
  add_index "comments", ["user_id"], name: "idx_comments_user_id", using: :btree
  add_index "comments", ["created_at"], name: "idx_comments_created_at", using: :btree

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total_cents", precision: 12, scale: 2, default: "0.0", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "orders", ["user_id"], name: "idx_orders_user_id", using: :btree
  add_index "orders", ["status"], name: "idx_orders_status", using: :btree
  add_index "orders", ["created_at"], name: "idx_orders_created_at", using: :btree

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "amount_cents", precision: 12, scale: 2, null: false
    t.string "gateway", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "payments", ["order_id"], name: "idx_payments_order_id", using: :btree
  add_index "payments", ["created_at"], name: "idx_payments_created_at", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "number", null: false
    t.decimal "amount_cents", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "invoices", ["order_id"], name: "idx_invoices_order_id", using: :btree
  add_index "invoices", ["number"], name: "idx_invoices_number", using: :btree
  add_index "invoices", ["created_at"], name: "idx_invoices_created_at", using: :btree

  add_foreign_key "posts", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "invoices", "orders"
end
