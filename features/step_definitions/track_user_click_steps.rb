require 'timecop'

Then /^(?:|I )should have a click value of (.+) for show_id of (.+)$/ do |num, show_id|
  assert User.all.first.interests.where(:show_id => show_id).first.click == Integer(num)
end

Given /^there is an entry with show_id (.+) with click value (.+)$/ do |show_id, num|
  User.all.first.interests.create(:show_id => show_id, :click => num)
end

