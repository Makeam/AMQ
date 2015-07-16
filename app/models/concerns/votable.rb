module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_vote(user)
    self.votes.find_by(user_id: user.id)
  end

  def rating!
    #sum = self.votes.sum(:weight)
    #self.update(rating: sum)
    #
    #self.votes.find_each( batch_size: 1 ) do | vote |
    #  self.increment!(:rating, vote.weight)
    #end
    #
    #return self.rating
  end

  #protected
  #
  #def update_rating
  #  self.votable.increment!(:rating, self.weight)
  #end
end