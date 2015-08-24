require_relative 'acceptance_config'

feature 'Searching feature' do
  given!(:question){create(:question, title: 'qwerty question')}
  given!(:answer){create(:answer, body: 'qwerty answer')}
  given!(:comment){create(:comment, body: 'qwerty comment')}
  given!(:user){create(:user, email: 'qwerty@test.ru')}

  scenario "User search within all objects", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      click_on 'Search'

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end
  scenario "User search within Questions", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'Question', from: 'search_filter'
      click_on 'Search'

      expect(page).to have_content question.title

      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email

    end
  end
  scenario "User search within Answers", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'Answer', from: 'search_filter'
      click_on 'Search'

      expect(page).to have_content answer.body

      expect(page).to_not have_content question.title
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end
  scenario "User search within Comments", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'Comment', from: 'search_filter'
      click_on 'Search'

      expect(page).to have_content comment.body

      expect(page).to_not have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content user.email
    end
  end
  scenario "User search within Users", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'User', from: 'search_filter'
      click_on 'Search'

      expect(page).to have_content user.email

      expect(page).to_not have_content question.title
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
    end
  end
end