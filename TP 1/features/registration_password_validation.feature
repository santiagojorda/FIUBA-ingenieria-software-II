Feature: Password validation during registration

  Background:
    Given I am on 'the registration screen'
    And I fill in valid new user data without password

  Scenario: US32.1 Valid password allows registration
    When I enter a password that meets all the conditions
    
    And I submit the form
    Then I am successfully registered

  Scenario: US32.2 Password too short
    When I enter a password with fewer than 8 characters
    And I submit the form
    Then The error "Password must be at least 8 characters long" is shown

  Scenario: US32.3 Password with no uppercase letters
    When I enter a password with only lowercase letters
    And I submit the form
    Then The error "Password must contain at least one uppercase letter" is shown

  Scenario: US32.4 Password with only one number
    When I enter a password with only one number
    And I submit the form
    Then The error "Password must contain at least two numbers" is shown

  Scenario: US32.5 Password with no special characters
    When I enter a password with no special characters
    And I submit the form
    Then The error "Password must contain at least one special character" is shown

  Scenario: US32.6 Password too long
    When I enter a password with more than 15 characters
    And I submit the form
    Then The error "Password must not exceed 15 characters" is shown
