class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = Question.find(params[:question_id]).answers
    respond_with @answers, each_serializer: AnswerInCollectionSerializer
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

end