
Given /^the database has been setup with similarshows.xml$/ do
  Show.fill_from_xml(File.join(Rails.root, "app", "data", "similarshows.xml"))
end

Given /^that (?:|I )am on the similar shows page with id "(.+)"$/ do |id_val|
  visit path_to('the similar shows page with id "' + id_val + '"')
end
