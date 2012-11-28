#/spec/db_assoc_spec.rb
require 'spec_helper'

describe Show do
  it 'test the many-to-many property between the Show and Category table' do
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

  it 'test that Show has many users through interests' do
    @show = FactoryGirl.build(:show)
    @show.save

    @show.users.create(:email => 'a')
    @show.users.first.email.should == 'a'
  end

  it 'test that User has many shows through interests' do
    @user = FactoryGirl.build(:user)
    @user.save

    @user.shows.create(:title => 'Looper')
    @user.shows.first.title.should == 'Looper'
  end

  it 'test that User has many interests' do
    @user = FactoryGirl.build(:user)
    @user.save

    @user.interests.create(:click => 2)
    @user.interests.first.click.should == 2
  end

  it 'test that Show has many interests' do
    @show = FactoryGirl.build(:show)
    @show.save

    @show.interests.create(:click => 4)
    @show.interests.first.click.should == 4
  end

  it 'test that User has and belongs to many categories' do
    @user = FactoryGirl.build(:user)
    @user.save

    @user.categories.create(:name => "Jazz")
    @user.categories.first.name.should == "Jazz"
  end

  it 'test that Interest belongs_to a Show and a Show has many Interests' do
    @show = FactoryGirl.build(:show)
    @show.save

    @new_interest = @show.interests.create(:click => 1)
    @show.interests.first.click.should == 1

    @new_interest.show.should == @show
  end

  it 'test that Interest belongs_to a User and a User has many Interests' do
    @user = FactoryGirl.build(:user)
    @user.save

    @new_interest= @user.interests.create(:click => 3)
    @user.interests.first.click.should == 3

    @new_interest.user.should == @user
  end
end
