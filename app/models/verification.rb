class Verification < ActiveRecord::Base
  validates :uid, :provider, :email, :token, presence: true
  validates :email, uniqueness: { scope: :provider}

  before_validation { self.token ||= SecureRandom.hex }

  def generate_token
    self.token ||= SecureRandom.hex
  end


end
