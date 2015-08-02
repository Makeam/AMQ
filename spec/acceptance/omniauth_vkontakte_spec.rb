require_relative 'acceptance_config'

feature 'User sign in with Vkontakte' do

  given(:registered_user) { create(:user) }

  scenario 'Registered User sign in with Vkontakte. Email provided.' do
    visit new_user_session_path
    omni_auth :vkontakte, registered_user.email
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    expect(page).to_not have_content 'Sign in'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Unregistered User sign in with Vkontakte. Email provided.' do
    visit new_user_session_path
    omni_auth :vkontakte, 'user@email.com'
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from vkontakte account.'
    expect(page).to_not have_content 'Sign in'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Registered User sign in with Vkontakte and does not provide email' do
    visit new_user_session_path
    omni_auth :vkontakte
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Sign in'
    expect(page).to have_content 'Adding email'

    fill_in 'E-mail', with: registered_user.email
    click_on 'Send me instructions'

    expect(page).to have_content 'We send instructions. Please check your e-mail.'

    #пользователь кликает на ссылку в письме
    open_email(registered_user.email)
    current_email.click_link 'Click here.'

    expect(page).to have_content 'Your email confirmed.'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_content 'Sign out'
  end


end