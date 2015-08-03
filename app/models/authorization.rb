class Authorization < ActiveRecord::Base

  validates :user_id, :uid, :provider, presence: true

  belongs_to :user

end
