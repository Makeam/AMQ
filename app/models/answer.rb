class Answer < ActiveRecord::Base

  validates :body, :question_id, presence: true
  validates :body, length: { in: 5..3000 }
  validates :question_id, numericality: { only_integer: true }

  belongs_to :question

end
