Feature: Administrator Account

  As a reviewer of applications,
  I want an account of administration privilege,
  so that I can manage applications.

Background:

  Given I am on the home page

Scenario: show all the applications to adminstrator
  When I fill in "user_username" with "admin"
  And I fill in "user_password" with "admin"
  And I press "登录"
  Then I should see "所有申请"
  And I should see "test_user1"
  And I should see "test_user2"

