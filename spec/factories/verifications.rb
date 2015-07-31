FactoryGirl.define do
  factory :verification do
    email "test@example.com"
    uid "123456"
    provider "Vkontakte"
    token "12317618347615834"
  end

end
