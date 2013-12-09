Feature: User Account

  As a applier using system,
  I want an rate of progress for forms
  So that I can know the progress more clearly.

Background:

  Given I am on the home page
  
Scenario: I can see the rate of progress
  When I fill in "user_username" with "test_user1"
  And I fill in "user_password" with "pass"
  And I press "登录"
  Then I should be on the list my app page of "test_user1"
  And I should see "未审核"

Scenario: I can see the rate of progress after checking a form
  When I fill in "user_username" with "admin"
  And I fill in "user_password" with "admin"
  And I press "登录"
  Then I should be on the application page for "admin"
  When I follow the first "接受"
  And I follow "注销"
  And I fill in "user_username" with "test_user1"
  And I fill in "user_password" with "pass"
  And I press "登录"
  Then I should see "正在审核中"

