FactoryGirl.define do
  factory :authorization do
    user
    provider "MyString"
    uid "123456"

    trait :for_vkontakte do
      provider 'vkontakte'
    end

    factory :vkontakte_authorization, traits:[:for_vkontakte]
  end

end
