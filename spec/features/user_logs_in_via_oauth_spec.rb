require 'spec_helper'

def stub_google(email)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: :google_oauth2,
    uid: "99",
    info: { email: email }
  })
end

def stub_facebook(email)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    provider: :facebook,
    uid: "101",
    info: { email: email }
  })
end


RSpec.feature "user logs in" do
  let(:email) { "user@example.com" }

  scenario "using Google" do
    stub_google(email)
    visit root_path
    expect(page).to have_link("Sign in with Google")
    click_link "Sign in with Google"
    expect(page).to have_content("Successfully authenticated from Google account.")
    expect(page).to have_link("Log out")
  end

  scenario "using Facebook" do
    stub_facebook(email)
    visit root_path
    expect(page).to have_link("Sign in with Facebook")
    click_link "Sign in with Facebook"
    expect(page).to have_content("Successfully authenticated from Facebook account.")
    expect(page).to have_link("Log out")
  end
end
