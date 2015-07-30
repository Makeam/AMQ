class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :set_best, :destroy]
  after_action :publish_answer, only: [:create]

  respond_to :json, except:[:destroy]
  respond_to :js, only:[:destroy]

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    if is_owner_of?(@answer)
      @answer.update(answer_params)
      respond_with @answer
    else
      flash[:notice] = 'You can\'t edit this answer.'
      render json: flash[:notice], status: :forbidden
    end
  end

  def set_best
    if is_owner_of?(@answer.question)
      respond_with @answer.set_best
    else
      flash[:notice] = 'You can\'t set Best answer.'
      render json: flash[:notice], status: :forbidden
    end
  end


  def destroy
    if is_owner_of?(@answer)
      @answer_id = @answer.id
      respond_with @answer.destroy
    else
      flash[:notice] ='You is not owner this answer.'
    end
  end


  private

  def publish_answer
    PrivatePub.publish_to "/question/#{@answer.question_id}/answers", response: (render_to_string 'answers/create.json.jbuilder') if @answer.valid?
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes:[:file])
  end

end
