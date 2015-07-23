class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :load_question, only:[:show, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question_id: @question_id)
    @answer.attachments.build

    gon.signed_in = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      PrivatePub.publish_to "/questions", response: create_hash
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if is_owner_of?(@question)
      if @question.update(question_params)
        flash[:notice] = 'Your Question successfully updated.'
      else
        flash[:notice] = 'Can not update your Question.'
        render json: @question.errors.full_messages, status: :unprocessable_entity
      end
    else
      flash[:notice] = 'You is not owner of this question.'
      render json: {}, status: :access_denied
    end
  end

  def destroy
    if @question.user_id == current_user.id
      if @question.destroy
        flash[:notice] = 'Your Question successfully deleted.'
        redirect_to questions_path
      else
        flash[:notice] = 'Can not delete your Question.'
        render :show
      end
    else
      flash[:notice] = 'You is not owner this question.'
      render :show
    end
  end

  private

  def create_hash
    {question: {title: @question.title, id: @question.id, user_email: @question.user.email}}.to_json
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes:[:file, :id, :_destroy])
  end

end
