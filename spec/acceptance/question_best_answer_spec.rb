require_relative 'acceptance_config'

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

feature 'Best answer is the first answer' do
  given(:user1){ create(:user)}
  given(:user2){ create(:user)}
  given(:question){ create(:question, user: user1) }
  given!(:answer1){create(:best_answer, question: question, user: user2)}
  given!(:answer2){create(:answer, question: question, user: user2)}

  scenario 'User select another answer as best and answer become first answer', js: true do
    sign_in(user1)
    visit question_path(question)
    within('.answers .answer:first-child') do
      expect(page).to have_content answer1.body
      expect(page).to have_content 'Best answer'
    end
    click_on 'Set best'
    within('.answers .answer:first-child') do
      expect(page).to have_content answer2.body
      expect(page).to have_content 'Best answer'
    end

  end
end
