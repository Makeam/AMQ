require_relative 'acceptance_config'


feature 'User can vote to answers and questions by another users' do

  given(:owner){ create(:user) }
  given(:user){ create(:user) }
  given(:question){ create(:question, user: owner) }
  given!(:answer){ create(:answer, user: owner, question: question) }

  before {
    sign_in(user)
    visit question_path(question)
  }

  scenario 'User can set vote UP to the answer', js: true do
    within('.answers') do
      click_on 'up'
      expect(page).to_not have_content 'up'
      within('.rating-sum') do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'User can set vote UP to the question', js: true do
    within('.question') do
      click_on 'up'
      expect(page).to_not have_content 'up'
      within('.rating-sum') do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'User can set vote DOWN to the answer', js: true do
    within('.answers') do
      click_on 'down'
      expect(page).to_not have_content 'down'
      within('.rating-sum') do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'User can set vote DOWN to the question', js: true do
    within('.question') do
      click_on 'down'
      expect(page).to_not have_content 'down'
      within('.rating-sum') do
        expect(page).to have_content '-1'
      end
    end
  end
end

feature 'User can\'t set vote twice but can cancel his vote' do

  given(:owner){ create(:user) }
  given(:user){ create(:user) }
  given(:question){ create(:question, user: owner) }
  given(:answer){ create(:answer, user: owner, question: question) }
  given!(:q_vote){ create(:question_vote, votable: question, user: user, weight: 1) }
  given!(:a_vote){ create(:answer_vote, votable: answer, user: user, weight: -1) }

  before {
    sign_in(user)
    visit question_path(question)
  }

  scenario 'User can\'t set vote twice to the question' do
    within('.question') do
      expect(page).to_not have_content 'up'
      expect(page).to have_content 'cancel my vote'
    end
  end

  scenario 'User can\'t set vote twice to the answer' do
    within('.answers') do
      expect(page).to_not have_content 'down'
      expect(page).to have_content 'cancel my vote'
    end
  end

  scenario 'User can cancel his vote to question', js: true do
    within('.question') do
      click_on 'cancel my vote'
      expect(page).to have_content 'up'
      expect(page).to have_content 'down'
      expect(page).to_not have_content 'cancel my vote'
    end
  end

  scenario 'User can cancel his vote to answer', js: true do
    within('.answers') do
      click_on 'cancel my vote'
      expect(page).to have_content 'up'
      expect(page).to have_content 'down'
      expect(page).to_not have_content 'cancel my vote'
    end
  end

end

feature 'User can\'t set vote to his votable' do

  given(:owner){ create(:user) }
  given(:question){ create(:question, user: owner) }
  given(:answer){ create(:answer, user: owner, question: question) }

  before {
    sign_in(owner)
    visit question_path(question)
  }

  scenario 'User can\'t set vote to his question' do
    within('.question') do
      expect(page).to_not have_content 'up'
      expect(page).to_not have_content 'down'
      expect(page).to_not have_content 'cancel my vote'
    end
  end

  scenario 'User can\'t set vote to his answer' do
    within('.answers') do
      expect(page).to_not have_content 'up'
      expect(page).to_not have_content 'down'
      expect(page).to_not have_content 'cancel my vote'
    end
  end

end
