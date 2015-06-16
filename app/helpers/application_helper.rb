module ApplicationHelper

  def is_owner_of?(obj)
    (user_signed_in? and (current_user.id == obj.user_id))
  end

end
