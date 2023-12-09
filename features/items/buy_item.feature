Feature: Buy items
  I want to be able to purchase the items I want

  Background:
    Given I am logged in
    And There are items on the market

  Scenario: User views item details
    When I navigate to an item's detail page
    Then I should see the item's details

  Scenario: User is not logged in and tries to purchase an item
    Given I am not logged in
    When I am on an item's detail page
    And I attempt to purchase the item
    Then I will be redirected to the sign in page

  Scenario: User is logged in and tries to purchase an item
    When I am on an item's detail page
    And I attempt to purchase the item
    Then I should be redirected to the checkout page

  Scenario: User confirms purchase with enough balance
    Given I am on the checkout page
    When I confirm the purchase
    And I do have enough balance
    Then I should be able to complete the purchase
    And My balance should decrease after the purchase

  Scenario: User confirms purchase with not enough balance
    Given I am on the checkout page
    When I confirm the purchase
    And I don't have enough balance
    Then I should not be able to complete the purchase
    And I should be redirected to home page

  Scenario: User decides to chat the owner
    Given I am on the checkout page
    When I want to make an offer to owner
    Then I will be redirected to chat screen