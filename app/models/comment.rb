class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :user_id, :commentable_id, :commentable_type, :body, presence: true
end
