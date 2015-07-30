class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def destroy
    @attachment = Attachment.find(params[:id])
    if is_owner_of?(@attachment.attachable)
      respond_with(@attachment.destroy)
    else
      flash[:notice] = 'File can\'t be deleted because you are not owner'
      render json: {id: params[:id]}, status: :forbidden
    end
  end

end
