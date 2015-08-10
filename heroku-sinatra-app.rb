# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for it's own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
require 'rubygems'
require 'sinatra'
require 'rest-client'
require 'nokogiri'
require 'json'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

# Enable CORS
options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

  # Needed for AngularJS
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

  halt HTTP_STATUS_OK
end

# Root
get '/' do
  "The source code for this app can be found here: https://github.com/tomchapin/twitter-search-relay"
end

# Search Twitter
get '/search.?:format?/?' do
  handle_twitter_search
end

post '/search.?:format?/?' do
  handle_twitter_search
end

# Test at <appname>.heroku.com

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

# get '/env' do
#   ENV.inspect
# end


# Supplemental methods

def handle_twitter_search
  content_type :json, 'charset' => 'utf-8'

  query = params[:query]
  if query.nil? || query.length == 0
    { errors: 'Missing parameter - query (example usage: /search?query=foo)' }.to_json
  else
    tweets = fetch_twitter_search_results(query)
    tweets.to_json
  end
end

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