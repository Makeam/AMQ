require_relative 'acceptance_config'

feature 'Add files to question' do
  given(:user){ create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when ask question' do
    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'
    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end

  scenario 'User adds some files when ask question', js: true do
    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'
    click_on 'Add file'
    within ('.question-attachments-fields .nested-fields:first-child') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    sleep(1)
    within ('.question-attachments-fields .nested-fields:nth-child(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Save'

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/2/spec_helper.rb"
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/3/rails_helper.rb"
  end
end

feature 'Add files to question' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when edit question', js: true do
    within (".question") do
      click_on 'Edit'
      sleep(1)
      click_on 'Add file'
      within ('.question-attachments-fields .nested-fields:first-child') do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'Save'
    end

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end
end