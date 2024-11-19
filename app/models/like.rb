class Like < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :finstagram_post

end