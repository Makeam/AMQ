require "rails_helper"

RSpec.describe VerificationMailer, type: :mailer do

  describe '#confirm_email' do
    let(:verification) { create(:verification) }
    let!(:email) { VerificationMailer.confirmation_email(verification) }


    it 'should send mail to email that needs to be verified' do
      expect(email.to.first).to eq verification.email
    end

    it 'should have subject with provider name' do
      expect(email.subject).to have_content("Confirm your #{verification.provider.capitalize} account")
    end
 end
end
