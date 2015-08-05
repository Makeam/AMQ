require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end


  def is_owner_of?(obj)
    (user_signed_in? and (current_user.id == obj.user_id))
  end

  def is_not_owner_of?(obj)
    !is_owner_of?(obj)
  end

end
