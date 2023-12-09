## methods ##
def create_guest
  @guest ||= {:email => "test@email.com", :password => "password123!"}
end

def find_user
  @user ||= User.where(:email => @guest[:email]).first
end

def create_user
  @user = User.create(:email => "test@email.com", :password => "password123!")
end

def delete_user
  create_guest
  @user ||= User.where(:email => @guest[:email]).first
  p @user
  @user.destroy unless @user.nil?
end


## Given ##
Given /^I do not exist as a user$/ do
  delete_user
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I am logged in$/ do
  @user = FactoryBot.create(:user)
  visit '/u/sign_in'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

## When ##
When /^I sign up with valid email and password$/ do
  create_guest
  visit 'users/sign_up'
  fill_in "user_email", :with => @guest[:email]
  fill_in "user_password", :with => @guest[:password]
  fill_in "user_password_confirmation", :with => @guest[:password]
  click_button "Sign up"
end

When /^I sign up with an existing email$/ do
  create_user
  visit 'users/sign_up'
  fill_in "user_email", :with => @user[:email]
  fill_in "user_password", :with => @user[:password]
  fill_in "user_password_confirmation", :with => @user[:password]
  click_button "Sign up"
end

When /^I sign (.*?) with an invalid email: "(.*?)"$/ do |action, invalid_email|
  if action == 'up'
    visit 'users/sign_up'
  else
    visit 'users/sign_in'
  end

  fill_in "user_email", :with => invalid_email
  fill_in "user_password", :with => "password123!"

  if action == 'up'
    fill_in "user_password_confirmation", :with => "password123!"
    click_button "Sign up"
  else
    click_button "commit"
  end
end

When /^I sign (.*?) with an invalid password: "(.*?)"$/ do |action, invalid_password|
  if action == 'up'
    visit 'users/sign_up'
  else
    visit 'users/sign_in'
  end
  fill_in "user_email", :with => "test@email.com"
  fill_in "user_password", :with => invalid_password

  if action == 'up'
    fill_in "user_password_confirmation", :with => invalid_password
    click_button "Sign up"
  else
    click_button "commit"
  end
end

When /^I sign up without a password confirmation$/ do
  create_guest
  visit 'users/sign_up'
  fill_in "user_email", :with => @guest[:email]
  fill_in "user_password", :with => @guest[:password]
  fill_in "user_password_confirmation", :with => ""
  click_button "Sign up"
end

When /^I sign up with a mismatched password confirmation$/ do
  create_guest
  visit 'users/sign_up'
  fill_in "user_email", :with => @guest[:email]
  fill_in "user_password", :with => @guest[:password]
  fill_in "user_password_confirmation", :with => "password123"
  click_button "Sign up"
end

When /^I sign in with email and password that does not exist$/ do
  delete_user
  visit 'users/sign_in'
  fill_in "user_email", :with => @guest[:email]
  fill_in "user_password", :with => @guest[:password]
  click_button "commit"
end

When /^I sign in with valid email and password$/ do
  create_user
  visit 'users/sign_in'
  fill_in "user_email", :with => @user[:email]
  fill_in "user_password", :with => @user[:password]
  click_button "commit"
end

## And ##
And /^I should be signed out$/ do
  visit '/users/sign_out'
end

And /^I am not logged in$/ do
  # visit '/users/sign_out'
  click_button "Sign out"
end


## Then ##
Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see a user exists message$/ do
  page.should have_content "Email has already been taken"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see an invalid password message$/ do
  page.should have_content "Password is too short (minimum is 6 characters)"
end

Then /^I should see an blank password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password confirmation doesn't match Password"
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid Email or password"
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end
