class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.attachable_type == 'Question' ? @attachable = Question.find(@attachment.attachable_id) : @attachable = Answer.find(@attachment.attachable_id)
    if current_user.id == @attachable.user_id
      @attachment.destroy ? flash[:notice] = 'File deleted successfully.' : flash[:notice] = 'File can\'t be deleted.'
    else
      flash[:notice] = 'File can\'t be deleted because you are not owner'
    end
  end

end
