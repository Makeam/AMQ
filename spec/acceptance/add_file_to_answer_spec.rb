require_relative 'acceptance_config'

feature 'Add files to answer' do
  given(:user){ create(:user) }
  given(:question){ create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when create answer', js: true do
    fill_in 'Body', with: 'Body answer text'
    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save answer'

    within '.answers' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    end
  end

  scenario 'User adds some files when create answer', js: true do
    fill_in 'Body', with: 'Body answer text'
    within ('.answer-attachments .nested-fields:first-child') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add file'
    sleep(1)
    within ('.answer-attachments .nested-fields:nth-child(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Save answer'

    within '.answers' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    end
  end
end