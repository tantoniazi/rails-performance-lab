# frozen_string_literal: true

class CreateUserPostCountsMaterializedView < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE MATERIALIZED VIEW user_post_counts AS
      SELECT user_id AS id, COUNT(*) AS posts_count
      FROM posts
      GROUP BY user_id;
    SQL
    execute "CREATE UNIQUE INDEX idx_user_post_counts_id ON user_post_counts (id);"
  end

  def down
    execute "DROP MATERIALIZED VIEW IF EXISTS user_post_counts;"
  end
end
