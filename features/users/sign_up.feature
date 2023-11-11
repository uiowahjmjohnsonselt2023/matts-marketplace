Feature: Sign up
  I want to be able to sign up
  As a user who does not have an account,
  I want to be able to create a new account,
  so I can buy and sell things

  Background:
    Given I do not exist as a user

  Scenario: User signs up with valid email and password
    When I sign up with valid email and password
    Then I should see a successful sign up message

  Scenario: User signs up with an existing email
    When I sign up with an existing email
    Then I should see a user exists message

  Scenario: User signs up with invalid email
    When I sign up with an invalid email: "notemail"
    Then I should see an invalid email message

  Scenario: User signs up with invalid password
    When I sign up with an invalid password: "pass"
    Then I should see an invalid password message

  Scenario: User signs up with blank password
    When I sign up with an invalid password: ""
    Then I should see an blank password message

  Scenario: User signs up without password confirmation
    When I sign up without a password confirmation
    Then I should see a mismatched password message

  Scenario: User signs up with mismatched password and confirmation
    When I sign up with a mismatched password confirmation
    Then I should see a mismatched password message