# model code to represent the records of data in the DB
class User < ActiveRecord::Base

  # association methods
  has_many :finstagram_posts
  has_many :comments
  has_many :likes

  # validations
  validates :email, :username, uniqueness: true
  validates :email, :username, :avatar_url, :password, presence: true

end