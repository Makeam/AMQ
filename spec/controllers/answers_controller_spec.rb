require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:question) { FactoryGirl.create(:question) }

  describe 'POST #create User sign in' do
    sign_in_user
    context 'with valid attributes' do
      it 'redirects to question#show view' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end

      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'creates аn answer associated with the question' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer)
        answer = assigns(:answer)
        expect(answer.question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-renders question#show view' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer)
        expect(response).to render_template ('questions/show')
      end
    end
  end


end
