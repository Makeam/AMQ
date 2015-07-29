class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :load_question, only:[:show, :update, :destroy]
  before_action :setup_gon_instance, only:[:show]
  after_action :publish_to, only:[:create]

  respond_to :json, only:[:update]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    if is_owner_of?(@question)
      @question.update(question_params)
      respond_with @question
    else
      flash[:notice] = 'You is not owner of this question.'
      render json: {}, status: :access_denied
    end
  end

  def destroy
    if is_owner_of?(@question)
      respond_with(@question.destroy)
    else
      flash[:notice] = 'You is not owner this question.'
      render :show
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def publish_to
    PrivatePub.publish_to "/questions", response: (render_to_string 'questions/create.json.jbuilder') if @question.valid?
  end

  def setup_gon_instance
    gon.signed_in = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes:[:file, :id, :_destroy])
  end

end
