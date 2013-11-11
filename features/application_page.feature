Feature: Application Page

  As an administrator,
  I want an application form for users,
  so that they can apply for loan.

Background:

  Given I am on the home page

Scenario: show all the applications to adminstrator
  When I fill in "user_username" with "test_user1"
  And I fill in "user_password" with "pass"
  And I press "登录"
  And I follow "填写报销申请"
  Then I should be on the reimbursement application page of "test_user1"
  When I fill in "app_details" with "abcdef"
  And I fill in "app_amount" with "100"
  And I press "提交"
  Then I should see "abcdef"
