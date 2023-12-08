## Given ##
Given /^I (.*?) have items sold in the past$/ do |arg|
  if arg == 'do'
    pending
  else
    pending
  end
end

Given /^I am adding a new item$/ do
  visit '/sellers'
  click_button 'Add New Item'
end

## When ##
When /^I click on the sell tab$/ do
  click_button 'Sell'
end

When /^I create new item with (.*?) input$/ do |arg|
  if arg == 'valid'
    fill_in 'item_price', :with => 100
  else
    fill_in 'item_price', :with => '100 dollars'
  end
  fill_in 'item_description', :with => 'Microwave'
  fill_in 'item_image_url', :with => 'www.image'
  # category how to do collection select
  check 'item_for_sale'
  click_button 'Sell Item'
end

## And ##
And /^I will be redirected to the sign in page$/ do
  page.should have_content 'Log in'
end

## Then ##
Then /^I will not be able to access the page$/ do
  page.should have_content "You must be logged in to use this feature"
end

Then /^I will see the new item on the sellers page$/ do
  page.should have_content 'Microwave'
end

Then /^I will stay on the same page$/ do
  page.should have_content 'Your items'
end

Then /^I will see items I've sold on the page$/ do
  pending
end


Then /^I will not see any items on the page$/ do
  page.should have_content "No items sold yet"
end