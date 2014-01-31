Feature: User Actions

  Scenario: Login with valid creds
    Given I am on the login page
    When I press "Sign In" with valid creds
    Then I should be on the home page
    And I should see "Home Page!"

  Scenario: Login with invalid creds
    Given I am on the login page
    When I press "Sign In" with invalid creds
    Then I should be on the login page
