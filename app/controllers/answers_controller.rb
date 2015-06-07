class AnswersController < ApplicationController

  before_action :authenticate_user!


  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer successfully created'
      redirect_to @answer.question
    else
      flash[:notice] = 'Upss! Can not create Answer.'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
