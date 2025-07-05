Feature: Home page

  Scenario: Browse default page
    When I browse the default page
    Then I should see a registration menu
    And I should see a job offers menu
