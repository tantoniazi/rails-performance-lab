# frozen_string_literal: true

class CreatePerformanceLabTables < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name
      t.boolean :active, default: true, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end
    add_index :users, :email, name: "idx_users_email"
    add_index :users, :active, name: "idx_users_active"
    add_index :users, :created_at, name: "idx_users_created_at"
    add_index :users, :email, name: "idx_users_active_email", where: "active = true"
    add_index :users, :metadata, name: "idx_users_metadata_gin", using: :gin

    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.datetime :published_at
      t.integer :comments_count, default: 0, null: false
      t.timestamps
    end
    add_index :posts, :published_at, name: "idx_posts_published_at"
    add_index :posts, :created_at, name: "idx_posts_created_at"
    add_index :posts, [:user_id, :created_at], name: "idx_posts_user_created"

    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.boolean :approved, default: false, null: false
      t.timestamps
    end
    add_index :comments, :created_at, name: "idx_comments_created_at"

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_cents, precision: 12, scale: 2, default: 0.0, null: false
      t.string :status, default: "pending", null: false
      t.timestamps
    end
    add_index :orders, :status, name: "idx_orders_status"
    add_index :orders, :created_at, name: "idx_orders_created_at"

    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :amount_cents, precision: 12, scale: 2, null: false
      t.string :gateway, null: false
      t.timestamps
    end
    add_index :payments, :created_at, name: "idx_payments_created_at"

    create_table :invoices do |t|
      t.references :order, null: false, foreign_key: true
      t.string :number, null: false
      t.decimal :amount_cents, precision: 12, scale: 2, null: false
      t.timestamps
    end
    add_index :invoices, :number, name: "idx_invoices_number"
    add_index :invoices, :created_at, name: "idx_invoices_created_at"
  end
end
