Feature: User Account

  As a applier using system,
  I want a user center for the appliers,
  so that I can manage their acounts and check their submissions or applications.

Background:

  Given I am on the home page
  
Scenario: I can login
  When I fill in "user_username" with "test_user1"
  And I fill in "user_password" with "pass"
  And I press "登录"
  Then I should be on the list my app page of "test_user1"

Scenario: list all my applications
  When I fill in "user_username" with "test_user1"
  And I fill in "user_password" with "pass"
  And I press "登录"
  Then I should see "test003"
  And I should not see "test005"

