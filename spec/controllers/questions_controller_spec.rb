require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let (:question){FactoryGirl.create(:question)}

  describe 'GET #index' do
    let(:questions) {FactoryGirl.create_list(:question,2)}

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'question actions' do
      before { get :show, id: question }

      it 'assign the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it "assign new answer object for answer's form" do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'builds new attachment for answer' do
        expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
      end


      it 'render show view' do
        expect(response).to render_template :show
      end
    end
    context 'Answers actions' do
      let!(:question1){create(:question)}
      let!(:answer1){create(:answer, question: question1)}
      let!(:answer2){create(:answer, question: question1)}
      let!(:answer3){create(:answer, question: question1)}
      before { get :show, id: question }

      it 'Orders answers by best desc' do
        answer2.best = true
        assigns(:question)
        expect(question.answers).to eq(Answer.where("best = TRUE AND question_id = :qid", {qid: question.id}).order('best desc'))
      end
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:user1){ create(:user) }

    context 'Authenticated user try create question with valid attributes' do
      before { sign_in(user1) }
      it 'saves the new question in the database' do
        expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'assigns the question with current user' do
        post :create, question: FactoryGirl.attributes_for(:question)
        question = assigns(:question)
        expect(question.user_id).to eq user1.id
      end

      it 'redirects to show view' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'Authenticated user try create question with invalid attributes' do
      before { sign_in(user1) }
      it 'does not save the question' do
        expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: FactoryGirl.attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
    context 'Non-authenticated user try create question' do
      it 'does not save the question' do
        expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
    end
  end

  describe 'POST #destroy' do

    let(:owner){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question) { create(:question, user: owner) }

    it 'User is owner of question' do
      sign_in(owner)
      expect{ post :destroy, id: question.id }.to change(Question, :count).by(-1)
    end

    it 'User is not owner of question' do
      sign_in(user2)
      expect{ post :destroy, id: question.id }.to_not change(Question, :count)
    end
  end

  describe 'PATCH #update' do
    let(:owner){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question) { create(:question, user: owner) }

    it 'Answer\'s owner can edit answer' do
      sign_in(owner)
      patch :update, id: question, question: {title:'New title question',body:'New body question'}, format: :json
      question.reload
      expect(question.title).to eq 'New title question'
      expect(question.body).to eq 'New body question'
    end


    it 'Not owner can\'t edit answer' do
      sign_in(user2)
      patch :update, id: question, question: {title:'New title question',body:'New body question'}, format: :json
      question.reload
      expect(question.title).to_not eq 'New title question'
      expect(question.body).to_not eq 'New body question'
    end

    it 'Non-authenticated user can\'t edit answer' do
      patch :update, id: question, question: {title:'New title question',body:'New body question'}, format: :json
      question.reload
      expect(question.title).to_not eq 'New title question'
      expect(question.body).to_not eq 'New body question'
    end

  end
end
