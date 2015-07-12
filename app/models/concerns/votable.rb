module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_vote(user)
    self.votes.find_by(user_id: user.id)
  end

  def rating!
    sum = self.votes.sum(:weight)
    self.update(rating: sum)
    return sum
  end

end