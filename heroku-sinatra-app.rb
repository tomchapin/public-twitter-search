# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'rest-client'
require 'nokogiri'
require 'pry'

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

# Quick test
get '/' do
  "The source code for this app can be found here: https://github.com/tomchapin/twitter-search-relay"
end

# Search Twitter
get '/search/?' do
  content_type :json
  keywords = params[:keyword] || params[:keywords]
  if keywords.nil? || keywords.length == 0
    { errors: 'Missing parameter: keyword (or keywords)' }.to_json
  else
    tweets = fetch_twitter_search_results(keywords)
    tweets.to_json
  end
end

# Test at <appname>.heroku.com

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

# get '/env' do
#   ENV.inspect
# end


# Supplemental methods

def fetch_twitter_search_results(query)
  twitter_search_url = "https://twitter.com/search?f=tweets&vertical=default&q=#{query}&src=typd"
  data               = RestClient.get(twitter_search_url)
  html               = Nokogiri::HTML(data)
  html.css('.tweet').map do |tweet|
    begin
      {
          "data-timestamp"      => tweet.css('.tweet-timestamp span').first["data-time-ms"].to_i,
          "data-tweet-id"       => tweet.attributes["data-tweet-id"].text.to_i,
          "data-item-id"        => tweet.attributes["data-item-id"].text.to_i,
          "data-permalink-path" => tweet.attributes["data-permalink-path"].text,
          "data-screen-name"    => tweet.attributes["data-screen-name"].text,
          "data-name"           => tweet.attributes["data-name"].text,
          "data-user-id"        => tweet.attributes["data-user-id"].text.to_i,
          "data-text"           => tweet.css('.tweet-text').children.text,
      }
    rescue
      nil
    end
  end.compact
end