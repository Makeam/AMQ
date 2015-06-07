class QuestionsController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :load_question, only:[:show, :edit, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question_id: @question_id)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
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

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
