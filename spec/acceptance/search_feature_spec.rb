require_relative 'acceptance_config'

feature 'Searching feature' do
  given!(:question){create(:question, title: 'qwerty question')}
  given!(:answer){create(:answer, body: 'qwerty answer')}

  scenario "User search within all objects", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      click_on 'Search'

      expect(page).to have_content question.body
      expect(page).to have_content answer.body
    end
  end
  scenario "User search within Questions", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'Question', from: 'search_filter'
      click_on 'Search'

      expect(page).to have_content question.body
      expect(page).to_not have_content answer.body
    end
  end
  scenario "User search within Answers", sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in 'search_query', with: 'qwerty'
      select 'Answer', from: 'search_filter'
      click_on 'Search'

      expect(page).to_not have_content question.body
      expect(page).to have_content answer.body
    end
  end
end