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
  Then I should be on the application page for "admin"
  And I should see "test005"
  And I should see "test006"

Scenario: Can not be visited if login time is out
  When I go to the application page for "admin"
  Then I should be on the Chinese home page
  And I should see "Login timed out!"
  When I go to the wait for verify page for admin
  Then I should be on the Chinese home page
  And I should see "Login timed out!"

