require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authentificated user
  I want to be able to ask  question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries create question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать вопрос'

    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'
    click_on 'Save'

    expect(page).to have_content 'Your question successfully created'

  end

  scenario 'Non-auntificated user tries to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end