class Like < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :finstagram_post

  # validations
  validates_presence_of :user, :finstagram_post

end