require_relative 'acceptance_config'


%w{question answers}.each do |attr|
  feature "VOTING to #{attr.capitalize}." do

    given!(:owner){ create(:user) }
    given!(:user){ create(:user) }
    given!(:question){ create(:question, user: owner) }
    given!(:answer){ create(:answer, user: owner, question: question) }


    feature "User can vote to #{attr.capitalize} by another user" do
      before {
        sign_in(user)
        visit question_path(question)
      }

      scenario "User can set vote UP to #{attr}", js: true do
        within(".#{attr}") do
          click_on 'up'
          expect(page).to_not have_content 'up'
          within('.rating-sum') do
            expect(page).to have_content '1'
          end
        end
      end
      scenario "User can set vote DOWN to #{attr}", js: true do
        within(".#{attr}") do
          click_on 'down'
          expect(page).to_not have_content 'down'
          within('.rating-sum') do
            expect(page).to have_content '-1'
          end
        end
      end

      feature "Lock double voting" do

        given!(:q_vote){ create(:question_vote, votable: question, user: user, weight: 1) }
        given!(:a_vote){ create(:answer_vote, votable: answer, user: user, weight: 1) }

        before {
          #sign_in(user)
          visit question_path(question)
        }
        scenario "User can\'t set vote twice to #{attr}", js: true do
          within(".#{attr}") do
            expect(page).to_not have_content 'up'
            expect(page).to have_content 'cancel my vote'
          end
        end

        scenario "User can cancel his vote to #{attr}", js: true do
          within(".#{attr}") do
            click_on 'cancel my vote'
            expect(page).to have_content 'up'
            expect(page).to have_content 'down'
            expect(page).to_not have_content 'cancel my vote'
          end
        end
      end
    end

    feature "User can't set vote to his #{attr}" do

      before {
        sign_in(owner)
        visit question_path(question)
      }

      scenario "User doesn't see buttons for voting to his #{attr}" do
        within(".#{attr}") do
          expect(page).to_not have_content 'up'
          expect(page).to_not have_content 'down'
          expect(page).to_not have_content 'cancel my vote'
        end
      end
    end
  end
end
