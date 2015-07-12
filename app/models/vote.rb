class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, :weight, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :weight, inclusion: { in: [-1, 1] }

end
