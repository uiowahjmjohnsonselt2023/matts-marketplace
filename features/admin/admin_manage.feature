Feature: Admin can view and manage all users and items

  As an admin,
  I want to be able to manage all users and items

  Background:
    Given I am logged in as an admin

  Scenario: Admin views all users
    When I visit the manage users page
    Then I should see a list of all users

  Scenario: Admin views all items
    When I visit the manage items page
    Then I should see a list of all items

  Scenario: Admin hides an item
    Given I am on the manage items page
    And I want to hide a specific item
    When I mark the item as not for sale
    Then the item should be hidden from the website

  Scenario: Admin bans a user
    Given I am on the manage users page
    When I ban a specific user
    Then the user will not be able view, buy, and sell items

  Scenario: Admin tries to ban themselves
    Given I am on the manage users page
    When I ban myself
    Then I will not be able to ban myself
