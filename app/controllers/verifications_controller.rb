class VerificationsController < ApplicationController

  def new
    @verification = Verification.new
  end

  def create
    @oauth = OmniAuth::AuthHash.new(session["devise.oauth_data"])

    unless verification_exists?
      @verification = Verification.create(verification_params.merge(provider: @oauth.provider, uid: @oauth.uid))
      VerificationMailer.confirmation_email(@verification).deliver_now if @verification.persisted?
      respond_with @verification
    else
      flash[:notice] = "We have already sent instructions. Please check your e-mail."
      redirect_to new_user_session_path
    end
  end

  def show
    @verification = Verification.find(params[:id])
  end

  def confirm
    @verification = Verification.where(id: params[:verification_id], token: params[:token]).first
    load_oauth_hash
    @user = User.find_for_oauth(@oauth_hash)
    if @user.persisted?
      flash[:notice] = "Your email confirmed.\n Successfully authenticated from #{@verification.provider.capitalize} account."
      @verification.destroy
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:notice] = "Uups. Something went wrong."
      redirect_to new_user_session_path
    end
  end

  private

  def verification_params
    params.require(:verification).permit(:email)
  end

  def verification_exists?
    Verification.exists?(email: params[:verification][:email], provider: @oauth.provider)
  end

  def load_oauth_hash
    @oauth_hash = OmniAuth::AuthHash.new({
        provider: @verification.provider,
        uid: @verification.uid,
        info: {
        email: @verification.email
        }
    })
  end

end
