require_relative 'acceptance_config'

feature 'Creating comment' do

  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, user: user, question: question) }

  scenario 'Authenticated user can leave comment to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within("#answer-#{answer.id}") do
      click_on 'Add comment'
      fill_in  'Comment', with: 'My comment'
      click_on 'Save'
      within(".comments") do
        expect(page).to have_content 'My comment'
      end
    end
  end

  scenario 'Authenticated user can leave comment to question', js: true do
    sign_in(user)
    visit question_path(question)
    within(".question") do
      click_on 'Add comment'
      fill_in  'Comment', with: 'My question comment'
      click_on 'Save'
      within(".comments") do
        expect(page).to have_content 'My question comment'
      end
    end
  end

  scenario 'Non-authenticated user can\'t leave comment' do
    visit question_path(question)
    expect(page).to_not have_content 'Add comment'
  end
end


