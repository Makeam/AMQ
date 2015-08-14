class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionInCollectionSerializer
  end

  def show
    respond_with @question = Question.find(params[:id])
  end

end