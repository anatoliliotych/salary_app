Feature: User Actions

  Scenario: Login with valid creds
    Given I am on the login page
    When I press "Войти" with valid creds
    Then I should be on the home page
    And I should see "Выйти"

  Scenario: Login with invalid creds
    Given I am on the login page
    When I press "Войти" with invalid creds
    Then I should be on the login page

  Scenario: Logout
    Given I am on the login page
    And I press "Войти" with valid creds
    And I should be on the home page
    And I should see "Выйти"
    When I press "Выйти"
    Then I should be on the login page
    And I should see "Войти"

  Scenario: View user info
    Given I am on the login page
    And I press "Войти" with valid creds
    And I should be on the home page
    And I select "December 2012" from "period"
    And I press "Установить"
    And I select "Лётыч Анатолий" from "name"
    When I press "Показать"
    Then I should see "Отчетный период: December 2012"
