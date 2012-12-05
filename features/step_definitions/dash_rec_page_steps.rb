Then /^I should only see (\d+) favorites$/ do |arg1|
    page.all(:css, '#recent.p').count.should be <= arg1.to_i
end

Then /^I should only see (\d+) recents$/ do |arg1|
    page.all(:css, '#favorites.p').count.should be <= arg1.to_i
end

Given /I previously filled out the recommendations form/ do
  step 'I am on the recommendations form page'
  step 'I fill in "recommendation_location_zip_code" with "94123"'
  step 'I press "Submit"'
end