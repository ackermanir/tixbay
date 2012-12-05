Then /^I should only see (\d+) favorites$/ do |arg1|
    page.all(:css, '#recent.p').count.should be <= arg1.to_i
end

Then /^I should only see (\d+) recents$/ do |arg1|
    page.all(:css, '#favorites.p').count.should be <= arg1.to_i
end
