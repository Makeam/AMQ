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
    click_on 'Add file'
    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save answer'

    attach = question.answers.first.attachments.first

    within '.answers' do
      expect(page).to have_link attach.file.filename, href: attach.file.url
    end
  end

  scenario 'User adds some files when create answer', js: true do
    fill_in 'Body', with: 'Body answer text'
    click_on 'Add file'
    within ('.answer-attachments .nested-fields:first-child') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'Add file'

    within ('.answer-attachments .nested-fields:nth-child(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Save answer'

    answer = question.answers.first
    attaches = []
    answer.attachments.each { |a| attaches << a }

    within '.answers' do
      expect(page).to have_link attaches[0].file.filename, href: attaches[0].file.url
      expect(page).to have_link attaches[1].file.filename, href: attaches[1].file.url
    end
  end
end

feature 'Add files to answer during editing' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when edit answer', js: true do
    within ("#answer-#{answer.id}") do
      click_on 'Edit'
      click_on 'Add file'
      within ('.answer-attachments-fields .nested-fields:first-child') do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'Save'
    end

    attach = question.answers.first.attachments.first

    within '.answers' do
      expect(page).to have_link attach.file.filename, href: attach.file.url
    end
  end
end