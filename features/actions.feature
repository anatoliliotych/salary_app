Feature: User Actions

  Scenario: Login with valid creds
    Given I am on the login page
    When I press "Sign in" with valid creds
    Then I should be on the home page
    And I should see "Sign out"

  Scenario: Login with invalid creds
    Given I am on the login page
    When I press "Sign in" with invalid creds
    Then I should be on the login page

  Scenario: Logout
    Given I am on the login page
    And I press "Sign in" with valid creds
    And I should be on the home page
    And I should see "Sign out"
    When I press "Sign out"
    Then I should be on the login page
    And I should see "Sign in"

