Feature: English Version
 
  As a non-Chinese native speaker,
  I want an English version website,
  so that the pages are readable for me.

Background:

  Given I am on the home page

Scenario: an English Version page
  When I follow "English Version"
  Then I should see "Home page of IIIS, Tsinghua"
  And I should not see "用户名"
  And I should see "中文版"

