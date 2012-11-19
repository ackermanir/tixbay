Given /I scroll to the bottom of the page/ do
  visit '#footer'
  #page.execute_script "window.scrollBy(0,10000)"
end

#Then /I scroll to the bottom of the page/ do
#  visit '#footer'
#end
