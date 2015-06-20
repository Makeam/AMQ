require_relative 'acceptance_config'

feature 'Changing ratings of answers' do

  given(:owner){create(:user)}
  given(:user){create(:user)}
  given(:question){create(:question,user: owner)}
  given!(:answer){create(:answer,user: owner, question: question)}

  scenario 'User can change up rating of answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'up'

    expect(find("#answer-#{answer.id}").find('.rating')).to have_content answer.rating
  end

  scenario 'User can\'t change rating of your answer' do
    sign_in(user)
    visit question_path(question)

    expect(find("#answer-#{answer.id}").find('.rating')).to_not have_content 'up'
    expect(find("#answer-#{answer.id}").find('.rating')).to_not have_content 'down'
  end

end