module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def user_vote(user)
    self.votes.find_or_initialize_by(user_id: user.id)
  end

end