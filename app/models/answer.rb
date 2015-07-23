class Answer < ActiveRecord::Base

  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user


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


end
