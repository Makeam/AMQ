require_relative 'acceptance_config'

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
    expect(page).to have_content 'My question text'
    expect(page).to have_content 'Body question text'

  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Задать вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end

feature 'Views questions', %q{
    In order to find the right question
    As user
    I want to see all questions
  }do

  given(:user) { create(:user) }
  before do
    create_list(:question, 2)
  end
  scenario 'Authenticated user tries to view list of questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content 'Question Title'
  end

  scenario 'Non-authenticated user tries to view list of questions' do
    visit questions_path

    expect(page).to have_content 'Question Title'
  end


end

feature 'View answers to the question', %q{
    In order to find the right answer
    As user
    I want to see all answers to this question
  }do

  given(:user){ create(:user) }
  given(:question){ create(:question) }
  given!(:answer){ create(:answer, question: question) }
  given!(:answer2){ create(:answer, question: question) }

  scenario 'Authenticated user look answers to the question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end


  scenario 'Non-authenticated user look answers to the question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body

  end

end

feature 'Delete question' do

  given(:user1){ create(:user) }
  given(:user2){ create(:user) }
  given(:question){ create(:question, user: user1) }

  scenario 'User is owner the question' do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete my question'

    expect(page).to have_content 'Your Question successfully deleted'
  end

  scenario 'User is NOT owner the question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete my question'
  end

  scenario "Non-authenticated user can't delete the question" do
    visit question_path(question)
    expect(page).to_not have_content 'Delete my question'
  end
end