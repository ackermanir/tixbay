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

Given /^I already filled out the recommendations form$/ do
    step 'I am on the recommendations form page'
    step 'I fill in "recommendation_location_zip_code" with "94123"'
    step 'I press "Submit"'
end
