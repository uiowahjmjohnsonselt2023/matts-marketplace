Feature: Sell items
  As a user who wants to earn money,
  I want to be able to sell my items

  Background:
    Given I am logged in

  Scenario: User is not logged in
    Given I am not logged in
    When I click on the sell tab
    Then I will not be able to access the page
    And I will be redirected to the sign in page

  Scenario: User does not have any items on sale yet
    Given I don't have items sold in the past
    When I click on the sell tab
    Then I will not see any items on the page

  Scenario: User has some items on sale
    Given I do have items sold in the past
    When I click on the sell tab
    Then I will see items I've sold on the page

  Scenario: User sells new item with valid input
    Given I am adding a new item
    When I create new item with valid input
    Then I will see the new item on the sellers page

  Scenario: User sells new item with invalid input
    Given I am adding a new item
    When I create new item with invalid input
    Then I will stay on the same page
#    And I will see a message

