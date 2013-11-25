Feature: Administrator Account

  As a reviewer of applications,
  I want to manage the applications,
  so that I can send the messages to the users.

Background:

  Given I am on the home page

Scenario: check and uncheck the apps
  When I fill in "user_username" with "admin"
  And I fill in "user_password" with "admin"
  And I press "登录"
  Then I should be on the application page for "admin"
  When I follow the first "接受"
  Then I should not see "test005"
  When I follow the first "待确认"
  Then I should see "test005" 
  And I should see "test003"
  And I should see "test004"
  When I follow the first "未审核"
  Then I should see "test006"
  When I follow the first "拒绝"
  Then I should not see "test006" 
  When I follow the first "待确认"
  Then I should not see "test006"

