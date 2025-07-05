@subscription
Feature: User registration with subscription selection

  Background:
    Given I am on 'the registration screen'
    And I fill in valid new user data


  Scenario: US53.1 New user registers with on-demand subscription
    Given I select the "on-demand" subscription
    When I submit the form
    Then I am successfully registered

  Scenario: US53.2 User with .org email can select org subscription
    Given I use an email "pedro@gmail.org"
    And I select the "org" subscription
    When I submit the form
    Then I am successfully registered

  Scenario: US53.3 User with non-.org email selects non-commercial subscription
    Given I use an email that does not end with .org
    And I select the "org" subscription
    When I submit the form
    Then The error 'Email is not valid for this subscription' is shown


  Scenario: US53.4 User submits form without selecting a subscription
    When I submit the form
    Then The error "Please select a subscription type to continue" is shown

