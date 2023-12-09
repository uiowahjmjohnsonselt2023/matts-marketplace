## Given ##
Given /^I (.*?) have items sold in the past$/ do |arg|
  if arg == 'do'
    users_with_items
  else
    users_without_items
  end
end

Given /^I am adding a new item$/ do
  visit '/sellers'
  click_button 'Add New Item'
end

## When ##
When /^I click on the (.*?) tab$/ do |action|
  if action == 'sell'
    click_link 'Sell'
  else
    click_link 'Buy'
  end
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
  visit '/sellers'
  # Count the number of item cards (adjust the selector as per your item card structure)
  user_item_cards_count = page.all('.w-full.max-w-sm.bg-white.border.border-gray-200.rounded-lg.shadow.flex.flex-col').count

  # Assert that the number of displayed items matches the number of items for the specific user
  expect(user_item_cards_count).to eq(@user_with_items.items.count)

  # users_with_items.items.each do |item|
  #   # expect(page).to have_content(item.description)
  #   expect(page).to have_selector('#item-description', text: item.description)
  # end
end


Then /^I will not see any items on the page$/ do
  page.should have_content "No items sold yet"
end