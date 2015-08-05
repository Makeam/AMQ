FactoryGirl.define do

  factory :vote, class: 'Vote' do
    user
    votable { |a| a.association(:question) }
    weight 1

    trait :question_vote do
      votable { |a| a.association(:question) }
    end

    trait :answer_vote do
      votable { |a| a.association(:answer) }
    end

    trait :vote_up do
      weight 1
    end

    trait :vote_down do
      weight -1
    end

    factory :answer_vote,        traits:[:answer_vote]
    factory :vote_up_answer,     traits:[:answer_vote, :vote_up]
    factory :vote_down_answer,   traits:[:answer_vote, :vote_down]
    factory :question_vote,      traits:[:question_vote]
    factory :vote_up_question,   traits:[:question_vote, :vote_up]
    factory :vote_down_question, traits:[:question_vote, :vote_down]
  end

end
