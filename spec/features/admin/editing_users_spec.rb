require 'rails_helper'

RSpec.feature "Admins can edit existing users" do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(admin)
    visit admin_user_path(user)
    click_link "Edit User"
  end

  scenario "with valid user credentials" do
    fill_in "Email", with: "newguy@example.com"
    click_button "Update User"

    expect(page).to have_content "User has been updated."
    expect(page).to have_content "newguy@example.com (User)"
    expect(page).not_to have_content user.email
  end

  scenario "when toggling a user's admin ability" do
    check "Is an admin?"
    click_button "Update User"

    expect(page).to have_content "User has been updated."
    expect(page).to have_content "#{user.email} (Admin)"
  end

end