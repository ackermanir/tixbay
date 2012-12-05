# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the theatre page$/
      '/category/theatre'
    when /^the film page$/
      '/category/film'
    when /^the music page$/
      '/category/music'
    when /^the recommendations form page$/
      '/recommendations/form'
    when /^the all culture page$/
      '/category/all_culture'
    when /^the show page with id "(.+)"$/
      '/show/'+$1
    when /^the sign in page$/
      '/users/sign_in'
    when /^the sign up page$/
      '/users/sign_up'
    when /^the recommendation page$/
      '/recommendations/index'
    when /^the logged in dashboard$/
      '/recommendations/index'
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
