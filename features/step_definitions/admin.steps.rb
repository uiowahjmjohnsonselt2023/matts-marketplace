## Given ##
Given /^I am logged in as an admin$/ do
  visit '/u/sign_in'
  fill_in 'Email', with: 'hans@uiowa.edu'
  fill_in 'Password', with: 'adminpassword'
  click_button 'Log in'
end

Given /^There are (\d+) existing users$/ do |n|
  @users = create_list(:user, n)
end


## When ##
When /^I am on the manage (.*?) page$/ do |type|
  if type == 'users'
    click_link 'Manage Users'
  elsif type == 'items'
    click_link 'Manage Items'
  else
    click_link 'Manage Purchases'
  end
end

When /^I mark the item as not for sale$/ do
  pending
end

When /^I ban a specific user$/ do
  pending
end

When /^I ban myself$/ do
  pending
end

## And ##
And /^I click on an item I want to hide$/ do
  pending
end

## Then ##
Then /^I will see the admin tab$/ do
  page.should have_content 'Admin'
end

Then /^I should see a list of all (.*?)$/ do |type|
  if type == 'users'
    pending
  elsif type == 'items'
    pending
  else
    pending
  end
end

Then /^the item should be hidden from the website$/ do
  pending
end

Then /^the user will banned from basic rights in the app$/ do
  pending
end

Then /^I will not be able to ban myself$/ do
  pending
end