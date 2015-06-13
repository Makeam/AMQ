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

feature 'Edit question' do
  given(:owner){ create(:user)}
  given(:user2){ create(:user)}
  given(:question){ create(:question, user: owner) }

  scenario 'Owner can edit question', js: true do
    sign_in(owner)
    visit question_path(question)
    within (".question") do
      click_on 'Edit'
      fill_in 'Title', with: 'New title question'
      fill_in 'Body', with: 'New body question'
      click_on 'Save'

      expect(page).to have_content 'New title question'
      expect(page).to have_content 'New body question'
    end
  end

  scenario 'Not owner can\'t edit question' do
    sign_in(user2)
    visit question_path(question)
    within('.question') do
      expect(page).to_not have_content 'Edit'
     end
  end

  scenario 'Non-authenticated user can\'t edit question' do
    visit question_path(question)
    within('.question') do
      expect(page).to_not have_content 'Edit'
    end
  end
end

feature 'Select best answer to the question' do
  given(:user1){ create(:user)}
  given(:user2){ create(:user)}
  given(:question){ create(:question, user: user1) }
  given!(:answer){create(:answer, question: question, user: user2)}
  given!(:answer2){create(:answer, question: question, user: user2)}

  scenario 'Question\'s owner can select one of answers as Best Answer', js: true do
    sign_in(user1)
    visit question_path(question)
    within("#answer-#{answer.id}") do
      click_on 'Set best'
    end
    within("#answer-#{answer2.id}") do
      click_on 'Set best'
    end
    within("#answer-#{answer.id}") do
      expect(page).to_not have_content 'Best answer'
    end
    within("#answer-#{answer2.id}") do
      expect(page).to have_content 'Best answer'
    end
  end

  scenario 'Not owner can\'t select answers as Best Answer' do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Set best'
  end

  scenario 'Non-authenticated user can\'t select answers as Best Answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Set best'
  end
end