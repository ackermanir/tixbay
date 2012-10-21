Then /^I should see shows$/ do
    page.should have_selector(:class => "show")
end

When /^I see a potential show I like$/ do
    pending # express the regexp above with the code you wish you had
end

Then /^I should be redirected to Goldstar$/ do
    current_path = URI.parse(current_url).path
    domain = /.*\.com/.match(current_path)
    assert_equal domain "www.goldstar.com"
    # response.should redirect_to(http://www.goldstar.com/)
    # pending
end

When /^I press the tix logo$/ do
    click_link("Redtopper")
end

When /^I press the "(.*?)" in the "(.*?)" section$/ do |arg1, arg2|
    with_scope(selector,:arg2) do
        click_link(arg1)
    end
end

When /^I press the "(.*?)" tab$/ do |arg1|
    pending # express the regexp above with the code you wish you had
end

Then /^I should see "(.*?)" shows$/ do |arg1|
    pending # express the regexp above with the code you wish you had
end
