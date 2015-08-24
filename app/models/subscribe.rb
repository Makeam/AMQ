class Subscribe < ActiveRecord::Base

  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: {scope: :question_id}

  belongs_to :user
  belongs_to :question
end
