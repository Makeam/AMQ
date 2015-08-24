class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers:[:facebook, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :subscribes, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy


  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    return User.new unless email

    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token(20)
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
    return user
  end

  def self.send_daily_digest
    find_each do |u|
      NewsMailer.daily_digest(u).deliver_later
    end
  end

end
