class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :set_best, :destroy]
  after_action :publish_answer, only: [:create]
  after_action :send_notification, only: [:create]

  respond_to :json, except:[:destroy]
  respond_to :js, only:[:destroy]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def set_best
    respond_with @answer.set_best
  end


  def destroy
    @answer_id = @answer.id
    respond_with @answer.destroy
  end


  private

  def send_notification
    if @answer.valid?
      #NewsMailer.new_answer_notification(@question).deliver_later
      NewAnswerNotificationJob.perform_later(@question)
      QuestionUpdateNotificationJob.perform_later(@question)
    end
  end

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
