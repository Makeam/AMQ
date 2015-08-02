class VerificationMailer < ApplicationMailer
  def confirmation_email(verification)
    @provider = verification.provider
    @link = verification_confirm_url(verification, token: verification.token)
    mail(to: verification.email, subject: "Confirm your #{@provider} account.")
  end
end
