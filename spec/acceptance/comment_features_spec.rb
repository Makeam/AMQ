require_relative 'acceptance_config'

feature 'Creating comment to answer' do

  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, user: user, question: question) }

  scenario 'Authenticated user can leave comment to answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Add comment'
    within('.new_comment') do
      fill_in  'Body', with: 'My comment'
      click_on 'Save'
    end
    within("#answer-#{answer.id} .comments") do
      expect(page).to have_content 'My comment'
    end
  end

  scenario 'Non-authenticated user can\'t leave comment to answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Add comment'
  end

end

feature 'Creating comment to question' do
  scenario 'Authenticated user can leave comment to question'
  scenario 'Non-authenticated user can\'t leave comment to question'
end

feature 'Deleting comment of answer' do
  scenario 'Authenticated user can delete his comment to answer'
  scenario 'Authenticated user can\'t delete alien comment to answer'
  scenario 'Non-authenticated user can\'t delete comment to answer'
end

feature 'Deleting comment of question' do
  scenario 'Authenticated user can delete his comment to question'
  scenario 'Authenticated user can\'t delete alien comment to question'
  scenario 'Non-authenticated user can\'t delete comment to question'
end

