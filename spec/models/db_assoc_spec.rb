#/spec/db_assoc_spec.rb
require 'spec_helper'

describe Show do
  it 'test the many-to-many property between the Show and Category table' do
    #s = Show.reflect_on_association(:categories)
    #s.macro.should == :has_and_belongs_to_many

    @show = FactoryGirl.build(:show)
    @category = FactoryGirl.build(:category)
    @show.save
    @category.save

    @show.categories.create(:name => 'Theater')
    @show.categories.first.name.should == 'Theater'

    @category.shows.create(:title => 'Inception')
    @category.shows.first.title.should == 'Inception'

  end

  it 'test that Show belongs_to a Venue and a Venue has many shows' do
    @venue = FactoryGirl.build(:venue)
    @venue.save

    @new_show = @venue.shows.create(:title => 'Test title')
    @venue.shows.first.title.should == 'Test title'

    @new_show.venue.should == @venue

  end

  it 'test that Show has_many Showtimes and a Showtime belongs_to a Show' do
    @show = FactoryGirl.build(:show)
    @show.save

    @new_showtime = @show.showtimes.create(:date_id => 22)
    @show.showtimes.first.date_id.should == 22

    @new_showtime.show.should == @show
  end
end
