Given /the following shows exist/ do |shows_table|
    shows_table.hashes.each do |show|
        Show.create!(show)
    end
    @show = Show.find_by_id(1)
end

Given /the following categories exist/ do |categories_table|
    categories_table.hashes.each do |category|
        Category.create!(category)
    end
end

Given /there are category and show associations/ do
    cat1 = Category.find_by_id(1)
    cat1.shows = [ Show.find_by_id(1), Show.find_by_id(2) ]
    cat1.save
    cat2 = Category.find_by_id(2)
    cat2.shows = [ Show.find_by_id(3)]
    cat2.save
    cat3 = Category.find_by_id(3)
    cat3.shows = [ Show.find_by_id(2), Show.find_by_id(4) ]
    cat3.save
end

When /^I see a potential show I like$/ do
    page.should include(@show)
end

Then /^I should be redirected to Goldstar$/ do
    # response.should redirect_to(http://www.goldstar.com/)
    pending
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
