class AnswersController < ApplicationController


  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @question = Question.find(params[:question_id])

    if @answer.save
      redirect_to @answer.question
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
