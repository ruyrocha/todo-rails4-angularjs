require 'spec_helper'

def stub_omniauth(uid, email)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: :google_oauth2,
    uid: uid,
    info: { email: email }
  })
end

RSpec.feature "user logs in" do
  scenario "using google oauth2" do
    stub_omniauth("99", 'user@example.com')
    visit root_path
    expect(page).to have_link("Sign in with Google")
    click_link "Sign in with Google"
    expect(page).to have_content("Successfully authenticated from Google account.")
    expect(page).to have_link("Log out")
  end
end