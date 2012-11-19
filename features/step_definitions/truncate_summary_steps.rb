require 'timecop'

Given /^(?:|I )wait for (.+) seconds?$/ do |val|
  sleep(val.to_i)
end
