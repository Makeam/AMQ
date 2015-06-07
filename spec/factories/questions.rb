FactoryGirl.define do
  factory :question do
    title "Question Title"
    body "Body of Question"
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil

  end
end
