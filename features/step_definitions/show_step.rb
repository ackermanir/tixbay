require 'timecop'

Given /^the database has been setup with similarshows.xml$/ do
  Show.fill_from_xml(File.join(Rails.root, "app", "data", "similarshows.xml"))
end

Given /^that (?:|I )am on the show page with id "(.+)"$/ do |id_val|
  visit path_to('the show page with id "' + id_val + '"')
end

Given /^the date is set to 2012$/ do
  Timecop.travel(DateTime.parse("2012-10-01"))
end
