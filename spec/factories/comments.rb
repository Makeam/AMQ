FactoryGirl.define do
  factory :comment do
    body "MyComment"
    user
    commentable { |a| a.association(:question) }

    trait :body_nil do
      body nil
    end

    factory :invalid_comment, traits:[:body_nil]
  end

end
