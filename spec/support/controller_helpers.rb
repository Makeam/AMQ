module ControllerHelpers
  def login_him(user)
    @user = user
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
  end
end