require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email}
  it { should validate_presence_of :password}
  it { should validate_uniqueness_of :email}

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.find_for_oauth' do

    let!(:user){ create(:user) }
    let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid:'123456') }
    context 'User already has authorisation' do
      it 'returns the User' do
        user.authorizations.create(provider: 'facebook', uid:'123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'User has not authrization' do
      context 'User already exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid:'123456', info: { email: user.email }) }
        it 'Does not create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end
        it 'Creates authrioaztion for User' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
        it 'Creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end

      context 'User does not exist' do
        let(:auth){ OmniAuth::AuthHash.new(provider:'facebook', uid:'123456', info: { email: 'new@user.com' }) }

        it 'Creates new User' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'Returns new User' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills User email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'Creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'Creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end
    end
  end
end
