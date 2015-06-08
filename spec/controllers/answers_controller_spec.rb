require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:user1) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }
  let (:question) { FactoryGirl.create(:question, user: user1) }
  let (:answer) { FactoryGirl.create(:answer, question: question, user: user1) }


  describe 'POST #create User signed in' do
    before{ sign_in(user1) }

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
        expect(answer.user_id).to eq user1.id
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


  describe 'POST #destroy' do
    before { answer }
    it 'User is owner of the Answer, and can delete him' do
      sign_in(user1)
      expect{ post :destroy, id: answer.id }.to change(question.answers, :count).by(-1)
    end

    it 'User is NOT owner of the Answer, and can\'t delete him' do
      sign_in(user2)
      expect{ post :destroy, id: answer.id }.to_not change(question.answers, :count)
    end
  end

end
