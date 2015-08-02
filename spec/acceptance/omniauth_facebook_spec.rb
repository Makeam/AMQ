require_relative 'acceptance_config'

feature 'User sing in with Facebook' do

  given(:registered_user) { create(:user) }

  scenario 'Registered User sign in via Facebook' do
    visit new_user_session_path
    omni_auth :facebook, registered_user.email
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to_not have_content 'Sign in'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Unregistered User sign in via Facebook' do
    visit new_user_session_path
    omni_auth :facebook, 'new@email.com'
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to_not have_content 'Sign in'
    expect(page).to have_content 'Sign out'
  end
end