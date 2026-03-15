# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :nullify
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
