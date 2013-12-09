Feature: Application Form

  As a reviewer of applications,
  I want an application form,
  so that I can manage forms more clearly.

Background:

  Given I am on the home page
  
Scenario: show all the application forms
  When I fill in "user_username" with "admin"
  And I fill in "user_password" with "admin"
  And I press "登录"
  Then I should see "test003"
  And I should see "test004"
  And I should see "test005"
  And I should see "test006"
