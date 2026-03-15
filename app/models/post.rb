# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  # counter_cache: true would use posts.comments_count; we keep it in sync via seeds/callback
  validates :title, presence: true
end
