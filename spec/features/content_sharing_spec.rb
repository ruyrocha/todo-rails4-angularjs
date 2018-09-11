require 'spec_helper'

describe "content sharing", type: :feature, js: true do
  let(:user) { create(:user) }
  let(:task_list) { create(:task_list, owner: user) }

  it "shows FB share button when checking task list page", js: true do
    login_as user, scope: :user

    visit "/task_lists/#{task_list.id}"

    expect(page).to have_css("div.fb-button--facebook")
  end
end
