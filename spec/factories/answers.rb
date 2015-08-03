FactoryGirl.define do
  sequence :body do |n|
    "Body of answer#{n}"
  end

  factory :answer do
    body
    question
    user
    best 'false'

    trait :best do
      best 'true'
    end

    trait :body_nil do
      body nil
    end

    factory :best_answer, traits:[:best]
    factory :invalid_answer, traits:[:body_nil]
  end

end
