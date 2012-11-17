Given /I already signed up/ do
    step 'I go to the sign up page'
    step 'I fill in "user_email" with "congchen@gg.com"'
    step 'I fill in "user_password" with "congchen"'
    step 'I fill in "user_password_confirmation" with "congchen"'
    step 'I fill in "user_zip_code" with "94709"'
    step 'I press "Sign up"'
    step 'I follow "Sign Out"'
end

Given /I am already logged in/ do
    step 'I already signed up'
    step 'I go to the sign in page'
    step 'I fill in "user_email" with "congchen@gg.com"'
    step 'I fill in "user_password" with "congchen"'
    step 'I press "Sign in"'  
    step 'I go to the home page'
end
