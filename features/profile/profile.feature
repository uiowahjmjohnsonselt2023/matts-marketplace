Feature: Profile
  As a logged in user
  I want to view and edit my profile

  Background:
    Given I am logged in

  Scenario: View Profile
    When I visit the Profile page
    Then I should see my profile information
    And I should see the link to purchase history
    And I should see the button to edit my profile

  Scenario: Edit Profile
    When I click on the "Edit Profile" button
    And I update my profile information
    And I click the "Save" button
    Then I should see a success message
    And my profile information should be updated