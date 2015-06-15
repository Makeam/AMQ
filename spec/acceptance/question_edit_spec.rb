require_relative 'acceptance_config'

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