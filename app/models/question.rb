class Question < ActiveRecord::Base

  belongs_to :user
  has_many :answers, -> { order "best DESC" },
           dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates :title, :body, :user_id, presence: true
  validates :title, length:{ in: 10..256 }
  validates :body, length:{ in: 5..3000 }

end
