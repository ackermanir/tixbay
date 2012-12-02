# spec/models/show_spec.rb
require 'spec_helper'
require 'rspec-rails'

describe Category do
  describe "self.shows_from_category" do
    it "calls from all files specified by type" do
      sh = mock('showtimes')
      sh.stub(:shows).and_return(["l"])
      Category.should_receive(:where).
        with(:name => ['Theatre', 'Performing Arts']).and_return([sh])
      Category.shows_from_category('theatre')
    end
  end
end
