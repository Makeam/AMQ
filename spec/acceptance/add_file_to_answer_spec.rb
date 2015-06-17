require_relative 'acceptance_config'

feature 'Add files to answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when ask question', js: true do
    fill_in 'Body', with: 'Body answer text'
    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save answer'

    within '.answers' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    end
  end
end