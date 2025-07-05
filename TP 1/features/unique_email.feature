@email
Feature: Email validation during registration

  Background:
    Given I am on 'the registration screen'
    And I fill in valid new user data minus email

  Scenario: US37.1 Valid email allows registration
    When I enter "juan@gmail.com" as an email for new user
    And I submit the form
    Then I am successfully registered
    
  Scenario: US37.2 Valid email that is already registered can't register again
    When there is a user registered with the email "lando@gmail.com"
    And I am on 'the registration screen'
    And I enter "lando@gmail.com" as an email for new user
    And I fill in valid new user data minus email
    And I submit the form
    Then The error "Email is already registered" is shown
