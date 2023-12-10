## Given ##
Given /^I am logged in as an admin$/ do
  visit '/u/sign_in'
  fill_in 'Email', with: 'hans@uiowa.edu'
  fill_in 'Password', with: 'adminpassword'
  click_button 'Log in'
end

Given /^There are (\d+) existing (.*?)$/ do |n, type|
  if type == 'users'
    @users = create_list(:user, n)
  elsif type == 'items'
    @items = create_list(:item, n)
  else
    @purchases = create_list(:purchase, n)
  end
end


## When ##
When /^I am on the manage (.*?) page$/ do |type|
  if type == 'users'
    visit '/admin/manage_users'
  elsif type == 'items'
    visit '/admin/manage_items'
  elsif type == 'purchase'
    visit '/manage_purchases'
  else
    visit '/admin/analytics'
  end
end

When /^I ban a specific user$/ do
  @fist_ban_link = first("button", text: "Ban")
end

When /^I ban myself$/ do
  pending
end

When /^I click on an item I want to hide$/ do
  first("a", text: "Edit").click
end

## And ##
And /^I mark the item as not for sale$/ do
  @item_to_hide = @items.first
  visit "/items/#{@item_to_hide.id}/admin_edit"
  uncheck 'item_for_sale'
end

## Then ##
Then /^I will see the admin tab$/ do
  page.should have_content 'Admin'
end

Then /^I should see a list of all (.*?)$/ do |type|
  if type == 'users'
    @users.each do |user|
      page.should have_content user.email
    end
  elsif type == 'items'
    @items.each do |item|
      page.should have_content item.description
    end
  else
    @purchases.each do |purchase|
      pending
    end
  end
end

Then /^the item should be hidden from the website$/ do
  expect(@item_to_hide.for_sale).to be(false)
  visit '/buyers'
  expect(page).to have_no_content(@item_to_hide.description)
end

Then /^the user will be banned from basic rights in the app$/ do
  @banned_user = create(:user, banned: true)
  sleep(0.5)
  visit 'users/sign_in'
  fill_in "user_email", :with => @banned_user[:email]
  fill_in "user_password", :with => @banned_user[:password]
  click_button "commit"
  page.should have_content 'You are banned from using the app. Please contact admin.'
end

Then /^I will not be able to ban myself$/ do
  pending
end