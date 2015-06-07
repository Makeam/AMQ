class Question < ActiveRecord::Base

  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length:{ in: 10..256 }
  validates :body, length:{ in: 5..3000 }

end
