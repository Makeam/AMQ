require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As an User
  I want sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with:'wrong@test.com'
    fill_in 'Password', with:'12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path

  end

end

feature 'User sign out', %q{
    In order to close session
    As authenticated user
    I want to sign out
  }do

  given(:user) { create(:user) }

  scenario 'Authenticated user signing out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end

end

feature 'Registration new user', %q{
    In order to ask questions
    As authenticated user
    I want registration
  }do

  scenario 'User tries registration' do
    visit new_user_registration_path
    fill_in 'Email', with: 'new_user_email@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'

  end
end