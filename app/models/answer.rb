class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { in: 5..3000 }
  validates :question_id, numericality: true

  def set_best
    self.question.answers.update_all(best: false)
    return self.update(best: true)
  end

end
