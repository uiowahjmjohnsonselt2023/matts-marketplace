Feature: Admin can see the revenue

  As an admin,
  I want to be able to see how much money I've made

  Scenario: Admin views total revenue
    Given I am logged in as an admin
    When I visit the analytics page
    Then I should see the total revenue generated