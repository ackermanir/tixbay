# spec/models/show_spec.rb
require 'spec_helper'
require 'rspec-rails'

describe Show do
  describe "fill_from_web" do
    it "loads the xml file" do
      #File.stub(:open).and_return("<Hello>")
      File.should_receive(:open).with(any_args()).and_return("<Hello>")
      Show.fill_from_web
    end
    it "creates an Event object if there is event data" do
      test = %Q{<listings><event id="46404"><summary_as_html>BATS
                Improv</summary_as_html></event>}

      fake_event = mock('event')
      File.stub(:open).and_return(test)
      Event.should_receive(:new).with(any_args()).and_return(fake_event)
      fake_event.should_receive(:process_event).with(no_args())
      Show.fill_from_web
    end
  end
end
