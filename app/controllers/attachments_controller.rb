class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    if is_owner_of?(@attachable)
      if @attachment.destroy
        flash[:notice] = 'File deleted successfully.'
        render json: {id: params[:id]}
      else
        flash[:notice] = 'File can\'t be deleted.'
        render json: @attachment.errors.full_messages, status: 500
      end
    else
      flash[:notice] = 'File can\'t be deleted because you are not owner'
      render json: {id: params[:id]}, status: :forbidden
    end
  end

end
