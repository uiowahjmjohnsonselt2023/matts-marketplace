Feature: Admin can view and manage all users and items

  As an admin,
  I want to be able to manage all users and items

  Background:
    Given I am logged in as an admin

  Scenario: Admin seeds the admin tab
    Then I will see the admin tab

  Scenario: Admin views all users
    Given There are 10 existing users
    When I am on the manage users page
    Then I should see a list of all users

  Scenario: Admin views all items
    When I am on the manage items page
    Then I should see a list of all items

  Scenario: Admin hides an item
    Given I am on the manage items page
    And I click on an item I want to hide
    When I mark the item as not for sale
    Then the item should be hidden from the website

  Scenario: Admin bans a user
    Given I am on the manage users page
    When I ban a specific user
    Then the user will banned from basic rights in the app

  Scenario: Admin tries to ban themselves
    Given I am on the manage users page
    When I ban myself
    Then I will not be able to ban myself
