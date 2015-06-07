FactoryGirl.define do
  sequence :body do |n|
    "Body of answer#{n}"
  end


  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer'  do
    body nil
    question
  end
end
