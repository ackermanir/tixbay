Given /I already signed up/ do
    step 'I go to the sign up page'
    step 'I fill in "user_first_name" with "Ben"'
    step 'I fill in "user_last_name" with "Bitdiddle"'
    step 'I fill in "user_email" with "congchen@gg.com"'
    step 'I fill in "user_password" with "congchen"'
    step 'I fill in "user_password_confirmation" with "congchen"'
    step 'I press "Sign Up"'
    step 'I follow "Log Out"'
end

Given /I am already logged in/ do
    step 'I already signed up'
    step 'I go to the sign in page'
    step 'I fill in "user_email" with "congchen@gg.com"'
    step 'I fill in "user_password" with "congchen"'
    step 'I press "Log In"'
    step 'I go to the home page'
end

Given /I already filled out the recommendations form/ do
  step 'I am already logged in'
  step 'I am on the recommendations form page'
  step 'I uncheck "recommendation_category_theatre"'
  step 'I uncheck "recommendation_category_popularmusic"'
  step 'I uncheck "recommendation_category_classical"'
  step 'I fill in "recommendation_startdate_month" with "10"'
  step 'I fill in "recommendation_startdate_day" with "10"'
  step 'I fill in "recommendation_startdate_year" with "2010"'
  step 'I fill in "recommendation_enddate_month" with "10"'
  step 'I fill in "recommendation_enddate_day" with "30"'
  step 'I fill in "recommendation_enddate_year" with "2014"'
  step 'I press "Submit"'
  step 'Show me the page'
  step 'I follow "Log Out"'
end
