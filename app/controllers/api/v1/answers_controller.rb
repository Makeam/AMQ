class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = Question.find(params[:question_id]).answers
    respond_with @answers, each_serializer: AnswerInCollectionSerializer
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id, attachments_attributes:[:file])
  end
end