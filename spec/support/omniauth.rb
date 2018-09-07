def stub_omniauth(uid, email)
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: :google_oauth2,
    uid: uid,
    info: { email: email }
  })
end
