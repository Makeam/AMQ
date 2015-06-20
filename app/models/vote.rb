class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :answer

  validates :user_id, :answer_id, :weight, presence: true
  validates :user_id, uniqueness: {scope: :answer_id}


end
