class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  has_many :votes, dependent: :destroy

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { in: 5..3000 }
  validates :question_id, numericality: true

  def set_best
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  def user_vote(user)
    self.votes.find_by(user_id: user.id)
  end

  def rating
    sum = 0
    self.votes.find_each do |v|
      sum += v.weight
    end
    return sum
  end

end
