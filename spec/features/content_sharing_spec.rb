require 'spec_helper'

RSpec.feature "sharing task lists" do
  let(:user) { create(:user) }
  let(:task_list) { create(:task_list, owner: user) }

  before do
    login_as(user, scope: :user)
  end

  scenario "via Facebook button" do
    visit "/"
    visit "/task_lists/#{task_list.id}"
    expect(page).to have_content("Remember me")
  end
end
