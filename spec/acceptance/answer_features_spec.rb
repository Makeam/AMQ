require_relative 'acceptance_config'

feature 'Creating answer to the question', %q{
    In order to help question's author
    As authenticated user
    I want to create an answer to the question
  }do

  given(:user){ create(:user) }
  given(:question){ create(:question) }

  scenario 'Authenticated user tries create an answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'My test answer'
    click_on 'Save answer'

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
  given!(:body_answer){ answer.body }

  scenario 'User is owner the question', js: true do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete my answer'


    expect(page).to_not have_content body_answer
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

feature 'Edit answer' do

  given(:owner){ create(:user) }
  given(:user){ create(:user) }
  given(:question){ create(:question, user: owner) }
  given!(:answer){ create(:answer, question: question, user: owner) }
  #given!(:answer2){ create(:answer, question: question, user: user) }

  scenario 'Answer\'s owner can edit the answer', js: true do
    sign_in(owner)
    visit question_path(question)
    within ("#answer-#{answer.id}") do
      click_on 'Edit'
      fill_in 'Body', with: 'New answer body'
      click_on 'Save'

      expect(page).to have_content 'New answer body'
    end
  end
  scenario 'Not owner can\'t edit the answer', js:true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content 'Edit'
  end
  scenario 'Non-authenticated user can\'t edit the answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Edit'
  end

end