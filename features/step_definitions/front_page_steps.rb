Given /the following shows exist/ do |shows_table|
    shows_table.hashes.each do |show|
        Show.create!(show)
    end
end

Given /the database has been setup from xml/ do
  Show.fill_from_xml(File.join(Rails.root, "app", "data", "cuke.xml"))
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
    step 'I should see "The Greatest Show"'
end

Then /^I should be redirected to Goldstar$/ do
    domain = current_url.match(/goldstar.com/i)
    assert_not_nil domain
end

Then /^I should be redirected to the Theatre Bay Area page$/ do
    domain = current_url.match(/www.theatrebayarea.org/i)
    assert_not_nil domain
end

When /^I press the tix logo$/ do
    click_link("Redtopper")
end

Then /^I should see "theater" shows$/ do
    step 'I should see "Avenue Q"'
    step 'I should see "Erickson Theatre"'
end

Then /^I should see "music" shows$/ do
    step 'I should see "Kristin Chenoweth"'
end

Then /^I should see "film" shows$/ do
    step 'I should see "BATS Improv Comedy"'
    step 'I should see "Marina Blvd"'
end

When /^I press the "(.*?)" tab$/ do |arg1|
    click_link(arg1)
end
