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
    expect(page).to_not have_content ('Save answer')
    expect(page).to_not have_css ('form')
  end

end

feature 'Delete answer' do

  given(:user1){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user: user1) }
  given!(:answer){ create(:answer, question: question, user: user1) }

  scenario 'User is owner the question' do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete my answer'

    expect(page).to have_content 'Answer successfully deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'User is NOT owner the question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete my answer'
  end

  scenario "Non-authenticated user can't delete answer" do
    visit question_path(question)
    expect(page).to_not have_content 'Delete my answer'
  end

end