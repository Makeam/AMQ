class AnswersController < ApplicationController

  before_action :authenticate_user!


  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:notice] = 'Your answer successfully created'
      redirect_to @answer.question
    else
      flash[:notice] = 'Upss! Can not create Answer.'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user_id == current_user.id
      if @answer.destroy
        flash[:notice] ='Answer successfully deleted.'
      else
        flash[:notice] ='Can not delete answer.'
      end
    else
      flash[:notice] ='You is not owner this answer.'
    end
    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
