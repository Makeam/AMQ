require 'rails_helper'

RSpec.describe VerificationsController, type: :controller do
  describe 'POST #create' do

    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
    before { session['devise.oauth_data'] = auth }

    it 'Creates new Verification and save in database' do
      expect{ post :create, verification:{ email: 'test@example.com'} }.to change(Verification, :count).by(1)
    end

    it 'assigns Verification to @verification' do
      post :create, verification:{ email: 'test@example.com'}
      verification = assigns(:verification)

      expect(verification).to_not be_a_new Verification

      expect(verification.email).to eq 'test@example.com'
      expect(verification.token).to_not be_empty
      expect(verification.uid).to eq '123456'
      expect(verification.provider).to eq 'vkontakte'
    end

    it 'Don\'t create double Verification' do
      post :create, verification:{ email: 'test@example.com'}
      expect{ post :create, verification:{ email: 'test@example.com'} }.to_not change(Verification, :count)
    end
  end

  describe 'GET #confirm' do
    let(:user){create(:user)}
    let(:verification){create(:verification, email: user.email)}
    it 'Delete verification' do
      expect{ get :confirm, verification_id: verification.id, token: verification.token }.to change(Verification, :count).by(-1)
    end
    it 'Create Authorization' do
      expect{ get :confirm, verification_id: verification.id, token: verification.token }.to change(Authorization, :count).by(1)
    end
    it 'Sign in User' do
      get :confirm, verification_id: verification.id, token: verification.token
      subject.current_user.should_not be_nil
    end
  end
end
