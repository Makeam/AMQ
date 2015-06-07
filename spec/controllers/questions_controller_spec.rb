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
    before { get :show, id: question }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it "assign new answer object for answer's form" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: FactoryGirl.attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: FactoryGirl.attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: FactoryGirl.attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: FactoryGirl.attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #destroy' do

    let(:user1){ create(:user) }
    let(:user2){ create(:user) }
    let(:question) { Question.create!(title:'Question title', body:'Question body', user_id: user1.id ) }
    before {
      question
    }

    it 'User is owner of question' do
      login_him(user1)
      expect{ post :destroy, id: question.id }.to change(Question, :count).by(-1)
    end

    it 'User is not owner of question' do
      login_him(user2)
      expect{ post :destroy, id: question.id }.to_not change(Question, :count)
    end
  end

end
