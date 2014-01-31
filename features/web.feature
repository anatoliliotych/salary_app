Feature: View pages

  Scenario: Open Login page
    Given I am on the login page
    Then I should see "Sign In"
    And the "username" field should exist
    And the "password" field should exist

  Scenario: Open Home page being unauthorized user
    Given I am on the login page
    When I go to the home page
    Then I should be on the login page
    And I should see "Sign In"


