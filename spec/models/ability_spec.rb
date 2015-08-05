require 'rails_helper'

describe Ability do
  subject(:ability){ Ability.new(user) }

  context 'for Guest' do
    let(:user){ nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  context 'for User' do
    let(:user){create(:user)}
    let(:user_2){create(:user)}
    let(:question){create(:question, user: user)}
    let(:question_2){create(:question, user: user_2)}
    let(:answer){create(:answer, question: question, user: user)}
    let(:answer_2){create(:answer, question: question_2, user: user_2)}
    let(:saved_vote){ create(:vote_up_question, votable: question, user: user)}
    let(:saved_vote_2){ create(:vote_up_question, votable: question_2, user: user_2)}
    let(:vote){ build(:question_vote, votable: question)}
    let(:vote_2){ build(:question_vote, votable: question_2)}
    let(:vote_3){ build(:answer_vote, votable: answer)}
    let(:vote_4){ build(:answer_vote, votable: answer_2)}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, question, user: user }
      it { should be_able_to :update, question, user: user }
      it { should_not be_able_to :update, question_2, user: user }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, answer, user: user }
      it { should be_able_to :update, answer, user: user }
      it { should_not be_able_to :update, answer_2, user: user }
    end

    context 'Set Best' do
      it { should be_able_to :set_best, answer, user: user}
      it { should_not be_able_to :set_best, answer_2, user: user}
    end

    context 'Voting' do
      it { should be_able_to :destroy, saved_vote, user: user }
      it { should_not be_able_to :destroy, saved_vote_2, user: user }
      it { should be_able_to :voting, vote_2, user: user}
      it { should_not be_able_to :voting, vote, user: user}
      it { should be_able_to :voting, vote_4, user: user}
      it { should_not be_able_to :voting, vote_3, user: user}
    end

  end

end