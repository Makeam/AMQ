class VerificationsController < ApplicationController

  def new
    @verification = Verification.new
  end

  def create
    @oauth = OmniAuth::AuthHash.new(session["devise.oauth_data"])
    @verification = Verification.new(verification_params.merge(provider: @oauth.provider, uid: @oauth.uid))
    @verification.generate_token
    if @verification.valid?
      @verification.save
      VerificationMailer.confirmation_email(@verification).deliver_later
      respond_with @verification
    end
  end

  def show
    @verification = Verification.find(params[:id])
  end

  def confirm
    @verification = Verification.where(id: params[:verification_id], token: params[:token]).first
    oauth_hash = OmniAuth::AuthHash.new({
        provider: @verification.provider,
        uid: @verification.uid,
        info: {
        email: @verification.email
        }
    })

    @user = User.find_for_oauth(oauth_hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Your email confirmed.\n Successfully authenticated from #{@verification.provider.capitalize} account."
    else
      #session["devise.oauth_data"] = request.env['omniauth.auth']
      redirect_to new_verification_path
    end

  end

  private

  def verification_params
    params.require(:verification).permit(:email)
  end

end
