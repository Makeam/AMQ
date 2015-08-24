require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let (:owner) { create(:user) }
  let (:user2) { create(:user) }
  let (:question) { create(:question, user: owner) }
  let (:answer) { create(:answer, question: question, user: owner) }


  describe 'POST #create User signed in' do

    let(:publish_path){ "/question/#{answer.question_id}/answers" }
    let(:request){ post :create, question_id: question, answer: attributes_for(:answer), format: :json }
    let(:invalid_params_request){ post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :json }

    before{ sign_in(owner) }

    context 'with valid attributes' do
      it 'Reaponse status: 200' do
        request
        expect(response.status).to eq 200
      end

      it 'saves the new answer in the database' do
        expect { request }.to change(Answer, :count).by(1)
      end

      it 'creates аn answer associated with the question' do
        request
        answer = assigns(:answer)
        expect(answer.user_id).to eq owner.id
        expect(answer.question_id).to eq question.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { invalid_params_request }.to_not change(Answer, :count)
      end

      it 'Response status: 422' do
        invalid_params_request
        expect(response.status).to eq 422
      end
    end

    it_behaves_like "Publishable"
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
    let(:update_request){
      patch :update, id: answer.id, question_id: question.id, answer: {body:'new answer body'}, format: :json
    }

    it 'Answer\'s owner can edit answer' do
      sign_in(owner)
      update_request
      answer.reload
      expect(answer.body).to eq 'new answer body'
    end

    it 'Renders set_best json' do
      sign_in(owner)
      update_request
      expect(response).to render_template ('update')
    end

    it 'Not owner can\'t edit answer' do
      sign_in(user2)
      update_request
      answer.reload
      expect(answer.body).to_not eq 'new answer body'
    end

    it 'Non-authenticated user can\'t edit answer' do
      update_request
      answer.reload
      expect(answer.body).to_not eq 'new answer body'
    end
  end

  describe 'PATCH #set_best' do
    let(:user1){ create(:user) }
    let(:user2){ create(:user) }
    let!(:question){ create(:question, user: user1) }
    let!(:answer){ create(:answer, question: question, user: user2) }
    let!(:answer2){ create(:answer, question: question, user: user2) }

    it 'Question\'s owner can select one of answers as Best answer' do
      sign_in(user1)
      patch :set_best, id: answer.id, format: :json
      patch :set_best, id: answer2.id, format: :json
      answer.reload
      answer2.reload

      expect(answer.best).to eq false
      expect(answer2.best).to eq true
    end

    context 'Owner of question set Best to the answer' do
      it 'Response status: 200' do
        sign_in(user1)
        patch :set_best, id: answer.id, format: :json
        expect(response.status).to eq 200
      end
    end

    it 'Not owner question can\'t select one of answers as Best answer' do
      sign_in(user2)
      patch :set_best, id: answer.id, format: :json
      answer.reload
      expect(answer.best).to eq false
    end

    it 'Non-authenticated user can\'t select one of answers as Best answer' do
      patch :set_best, id: answer.id, format: :json
      answer.reload
      expect(answer.best).to eq false
    end
  end
end
