module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_vote(user)
    self.votes.find_by(user_id: user.id)
  end

  def rating!
    sum = 0
    self.votes.find_each do |v|
      sum += v.weight
    end
    self.update(rating: sum)
    return sum
  end

end