class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = 'Comment successfully created.'

    else
      flash[:notice] = 'Error creating comment'
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def load_commentable
    model_klass = params[:comment][:commentable_type].classify.constantize
    @commentable = model_klass.find(params[:comment][:commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

end
