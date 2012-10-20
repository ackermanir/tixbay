# spec/models/event_spec.rb
require 'spec_helper'
require 'rspec-rails'

describe Event do
  it "sets event when initialized"
  describe "process_event" do
    it "works" do
      input = %Q{<listings><event id="46404"><deal_of_the_day>today_only</deal_of_the_day><full_price_range>$17.00</full_price_range><summary_as_text>Show twice.</summary_as_text><image>improv.jpg</image><venue><capacity>194</capacity><geocode_longitude>-122.433704</geocode_longitude><image>front.jpg</image><geocode_latitude>37.805033</geocode_latitude><link>theater</link><address><locality>San Francisco</locality><country_name>United States</country_name><postal_code>94123</postal_code><street_address>Marina Blvd At Buchanan St</street_address><region>CA</region></address><name>Bayfront Theater</name></venue><headline_as_text>BATS Improv</headline_as_text><link>sub=46404</link><upcoming_dates><event_date id="619189"><time_note>8:00pm (Improvised Horror Musical)</time_note><date>2012-10-20</date></event_date></upcoming_dates><title_as_text>BATS Improv Comedy</title_as_text><sold_out>false</sold_out><category_list><category id="1"><name>Comedy</name></category></category_list><our_price_range>FREE - $8.50</our_price_range></event></listings>}
      File.stub(:open).and_return(input)
      Show.fill_from_web
      Show.fill_from_web
    end
  end
end
