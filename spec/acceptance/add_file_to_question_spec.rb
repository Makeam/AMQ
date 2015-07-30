require_relative 'acceptance_config'

feature 'Add files to question' do
  given(:user){ create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when ask question', js: true do
    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'
    click_on 'Add file'
    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    attach = Question.first.attachments.first
    expect(page).to have_link attach.file.filename, href: attach.file.url
  end

  scenario 'User adds some files when ask question', js: true do
    fill_in 'Title', with: 'My question text'
    fill_in 'Body', with: 'Body question text'
    click_on 'Add file'
    within ('.question-attachments-fields .nested-fields:first-child') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add file'
    sleep(1)
    within ('.question-attachments-fields .nested-fields:nth-child(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Save'

    question = Question.first
    attaches = []
    question.attachments.each {|a| attaches << a }

    expect(page).to have_link attaches[0].file.filename, href: attaches[0].file.url
    expect(page).to have_link attaches[1].file.filename, href: attaches[1].file.url
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

    attach = Question.first.attachments.first
    expect(page).to have_link attach.file.filename, href: attach.file.url
  end
end