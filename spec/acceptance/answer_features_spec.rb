require 'rails_helper'

feature 'Creating answer to the question', %q{
    In order to help question's author
    As authenticated user
    I want to create an answer to the question
  }do

  given(:user){ create(:user) }
  given(:question){ create(:question) }

  scenario 'Authenticated user tries create an answer' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'My test answer'
    click_on 'Save answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'My test answer'
  end

  scenario 'Non-authenticated user tries create an answer' do
    visit question_path(question)

    expect(page).to have_content 'To answer the question you need to sign in'
  end

end