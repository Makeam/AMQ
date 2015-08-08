FactoryGirl.define do
  factory :comment do
    body "MyComment"
    user
    commentable { |a| a.association(:question) }
  end

end
