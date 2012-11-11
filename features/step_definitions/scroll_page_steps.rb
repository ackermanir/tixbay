Given /^we paginate after (\d+) (.*)$/ do |number, model_name|
  model = model_name.singularize.gsub(/[^A-z]+/, '_').camelize.constantize
  @overwritten_paginations ||= {}
  @overwritten_paginations[model] ||= model.per_page # Remember only the initial value, even if called multiple times
  model.per_page = number.to_i
end

After do
  if @overwritten_paginations
    @overwritten_paginations.each do |model, per_page|
      model.per_page = per_page
    end
  end
end

Then /^I should only see (\d+) shows$/ do |arg1|
  page.all(:css, '#listings.show').count.should be <= arg1.to_i
end

Then /^I should see (\d+) more shows$/ do |arg1|
    pending # express the regexp above with the code you wish you had
end

Given /^I hover over the bottom of the page$/ do
    pending # express the regexp above with the code you wish you had
end
