FactoryGirl.define do
  sequence :body do |n|
    "Body of answer#{n}"
  end


  factory :answer do
    body
    question
    user
    best 'false'
  end

  factory :best_answer, class: 'Answer' do
    body
    question
    user
    best 'true'
  end

  factory :invalid_answer, class: 'Answer'  do
    body nil
    question

  end
end
