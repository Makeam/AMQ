class SubscribesController < ApplicationController
  before_action :authenticate_user!

  respond_to :js
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with( @subscribe = current_user.subscribes.create(question_id: params[:question_id]))
  end

  def destroy
    @question = Subscribe.find(params[:id]).question
    respond_with( Subscribe.find(params[:id]).destroy )
  end

end
