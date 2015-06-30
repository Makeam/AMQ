class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :set_best, :destroy]


  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    respond_to do |format|
      if @answer.save
        flash[:notice] = 'Your answer successfully created'
        format.json #{render json: @answer}
      else
        flash[:notice] = 'Upss! Can not create Answer.'
        format.json { render json: @answer.errors.full_messages, status: :unprocessble_entity }
      end
    end

  end

  def update
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

  def set_best
    if @answer.question.user_id == current_user.id
      @question = @answer.question
      if @answer.set_best
        flash[:notice] = 'You set the answer as Best answer'
      else
        flash[:notice] = 'Upss! Best answer not set.'
      end

    else
      flash[:notice] = 'You can\'t set Best answer.'
    end
  end


  def destroy
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

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes:[:file])
  end

end
