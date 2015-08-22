require_relative 'acceptance_config'

feature 'Creating subscribe to the question' do

  given(:user){ create(:user) }
  given(:question){ create(:question) }

  scenario 'Authenticated user tries subscribes', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to have_content 'Subscribe was successfully created'
  end

  scenario 'Non-authenticated user tries subscribes' do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to_not have_content 'UnSubscribe'
  end

end

feature 'Deleting subscribe' do

  given!(:user){ create(:user) }
  given!(:question){ create(:question) }
  given!(:subscribe){ create(:subscribe, user: user, question: question) }

  scenario 'Authenticated user tries UnSubscribes', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'UnSubscribe'

    expect(page).to have_content 'Subscribe was successfully destroyed'
  end
end