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
      #expect(verification.id).to be_empty
      expect(verification.uid).to eq '123456'
      expect(verification.provider).to eq 'vkontakte'
    end
  end
end
