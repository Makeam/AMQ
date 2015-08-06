class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable
  before_action :load_comment
  after_action :publish_comment, only:[:create]

  respond_to :json

  def create
    authorize! :create, @comment
    respond_with(@comment)
  end

  private

  def load_comment
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  def load_commentable
    model_klass = params[:comment][:commentable_type].classify.constantize
    @commentable = model_klass.find(params[:comment][:commentable_id])
  end

  def get_question_id
    @comment.commentable_type == 'Question' ? @commentable.id : @commentable.question.id
  end

  def publish_comment
    PrivatePub.publish_to "/question/#{get_question_id}/comments", response: (render_to_string 'comments/create.json.jbuilder') if @comment.valid?
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

end
