FactoryGirl.define do
  factory :comment do
    body "MyComment"
    user_id
    commentable
  end

end
