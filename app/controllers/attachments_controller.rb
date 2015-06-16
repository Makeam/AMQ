class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachable = @attachment.attachable
    if is_owner_of?(@attachable)
      @attachment.destroy ? flash[:notice] = 'File deleted successfully.' : flash[:notice] = 'File can\'t be deleted.'
    else
      flash[:notice] = 'File can\'t be deleted because you are not owner'
    end
  end

end
