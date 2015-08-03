class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind:'Facebook') if is_navigational_format?
    end
  end

  def vkontakte
    oauth_perform
  end

  private

  def oauth_perform
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    provider = request.env['omniauth.auth'].provider
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.oauth_data"] = request.env['omniauth.auth']
      redirect_to new_verification_path
    end
  end
end