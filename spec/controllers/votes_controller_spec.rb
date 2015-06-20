require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe "PATCH #voting" do
    let(:owner){ create(:user)}
    let(:user){ create(:user)}
    let(:user2){ create(:user)}
    let!(:question){ create(:question, user: owner)}
    let!(:answer){ create(:answer, user: owner)}

    it 'Create new vote ' do
      sign_in(user)
      expect{ patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json }.to change(Vote, :count).by(1)
    end

    it 'Set Vote Up to Answer' do
      sign_in(user)
      expect{ patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json}.to change { answer.reload.rating }.by(1)
      #patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json
      #answer.reload
      #expect(answer.rating).to eq 1
    end

    it 'Set Vote Down to Answer' do
      sign_in(user)
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: -1, format: :json
      answer.reload
      expect(answer.rating).to eq -1
    end

    it 'Set 2 votes Up to Answer' do
      sign_in(user)
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json
      sign_out(user)
      sign_in(user2)
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json

      answer.reload
      expect(answer.rating).to eq 2
    end

     it 'Set Vote Up to Question' do
      sign_in(user)
      patch :voting, votable_id: question.id, votable_type: 'Question', weight: 1, format: :json
      question.reload
      expect(question.rating).to eq 1
    end

    it 'Set Vote Down to Question' do
      sign_in(user)
      patch :voting, votable_id: question.id, votable_type: 'Question', weight: -1, format: :json
      question.reload
      expect(question.rating).to eq -1
    end

    it 'The User can\'t set 2 votes Up to the Answer' do
      sign_in(user)
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json

      answer.reload
      expect(answer.rating).to_not eq 2
    end

    it 'The User can\'t set Vote to his Answer' do
      sign_in(owner)
      patch :voting, votable_id: answer.id, votable_type: 'Answer', weight: 1, format: :json
      answer.reload
      expect(answer.rating).to eq 0
    end

  end

  describe 'POST #destroy' do
    let(:owner){ create(:user)}
    let(:user){ create(:user)}
    let(:answer){ create(:answer, user: owner)}
    let!(:vote){ create(:answer_vote, votable: answer, user: user, weight: -1) }

    it 'Destroy vote ' do
      sign_in(user)
      expect{ post :destroy, id: vote.id, format: :json }.to change(Vote, :count).by(-1)
      answer.reload
      expect(answer.rating).to eq 0
    end

  end

end
