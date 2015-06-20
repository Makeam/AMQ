FactoryGirl.define do

  factory :question_vote, class: 'Vote' do
    user
    votable { |a| a.association(:question) }
    weight 0
  end

  factory :answer_vote, class: 'Vote' do
    user
    votable { |a| a.association(:answer) }
    weight 0
  end

end
