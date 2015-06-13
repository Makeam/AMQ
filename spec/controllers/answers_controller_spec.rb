require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:owner) { FactoryGirl.create(:user) }
  let (:user2) { FactoryGirl.create(:user) }
  let (:question) { FactoryGirl.create(:question, user: owner) }
  let (:answer) { FactoryGirl.create(:answer, question: question, user: owner) }


  describe 'POST #create User signed in' do
    before{ sign_in(owner) }

    context 'with valid attributes' do
      it 'renders create view' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
        expect(response).to render_template ('create')
      end

      it 'saves the new answer in the database' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js }.to change(Answer, :count).by(1)
      end

      it 'creates аn answer associated with the question' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:answer), format: :js
        answer = assigns(:answer)
        expect(answer.user_id).to eq owner.id
        expect(answer.question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post :create, question_id: question, answer: FactoryGirl.attributes_for(:invalid_answer), format: :js
        expect(response).to render_template ('create')
      end
    end
  end


  describe 'POST #destroy' do
    before { answer }
    it 'User is owner of the Answer, and can delete him' do
      sign_in(owner)
      expect{ post :destroy, id: answer.id, format: :js }.to change(question.answers, :count).by(-1)
    end

    it 'User is NOT owner of the Answer, and can\'t delete him' do
      sign_in(user2)
      expect{ post :destroy, id: answer.id, format: :js }.to_not change(question.answers, :count)
    end
  end

  describe 'PATCH #update' do
    before { answer }
    it 'Answer\'s owner can edit answer' do
      sign_in(owner)
      patch :update, id: answer.id, question_id: question.id, answer: {body:'new answer body'}, format: :js
      answer.reload
      expect(answer.body).to eq 'new answer body'
    end

    it 'Not owner can\'t edit answer' do
      sign_in(user2)
      patch :update, id: answer.id, question_id: question.id, answer: {body:'new answer body'}, format: :js
      answer.reload
      expect(answer.body).to_not eq 'new answer body'
    end

    it 'Non-authenticated user can\'t edit answer' do
      patch :update, id: answer.id, question_id: question.id, answer: {body:'new answer body'}, format: :js
      answer.reload
      expect(answer.body).to_not eq 'new answer body'
    end

  end

end
