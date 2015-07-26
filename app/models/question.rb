class Question < ActiveRecord::Base

  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, -> { order "best DESC" },
           dependent: :destroy


  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, :user_id, presence: true
  validates :title, length:{ in: 10..256 }
  validates :body, length:{ in: 5..3000 }

end
