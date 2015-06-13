class AnswersController < ApplicationController

  before_action :authenticate_user!


  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id

    if @answer.save
      flash[:notice] = 'Your answer successfully created'
    else
      flash[:notice] = 'Upss! Can not create Answer.'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.user_id == current_user.id
      @question = Question.find(params[:question_id])

      if @answer.update(answer_params)
        flash[:notice] = 'Your answer successfully created'
      else
        flash[:notice] = 'Upss! Can not create Answer.'
      end
    else
      flash[:notice] = 'You can\'t edit this answer.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer_id = @answer.id
    if @answer.user_id == current_user.id
      if @answer.destroy
        flash[:notice] ='Answer successfully deleted.'
      else
        flash[:notice] ='Can not delete answer.'
      end
    else
      flash[:notice] ='You is not owner this answer.'
    end
  end


  private

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
