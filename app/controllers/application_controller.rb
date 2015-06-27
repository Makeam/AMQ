class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def is_owner_of?(obj)
    (user_signed_in? and (current_user.id == obj.user_id))
  end

  def is_not_owner_of?(obj)
    !is_owner_of?(obj)
  end

end
