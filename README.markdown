# Public Twitter Search
This is a very light-weight app that allows you to search Twitter's publicly visible tweets,
without needing an API key.

It runs on Rack/Sinatra and uses the REST-client and Nokogiri gems to search the Twitter web site
and parse the HTML response page, converting the page of results into a JSON object.
By searching in this manner, it completely bypasses the Twitter API (and all of their API restrictions).

## Usage:

1. Install dependencies, using ```bundle install```
2. Install the foreman gem
3. Run the app, using ```foreman start```
4. GET the Twitter search JSON endpoint:

```
http://localhost:5000/search.json?query=foo
```

## Deployment

This app is ready for deployment to [Heroku](http://heroku.com).

* Create an account in seconds at [Heroku](http://heroku.com/signup).
* Install the gem `sudo gem install heroku`.
* If you do not have an SSH key
you'll need to [generate
one](http://heroku.com/docs/index.html#_setting_up_ssh_public_keys)
and [tell Heroku about
it](http://heroku.com/docs/index.html#_manage_keys_on_heroku)
* Clone this repo `git clone git@github.com:tomchapin/public-twitter-search.git [appname]`
* `cd /path/to/project`
* `heroku create [optional-app-name]` (You can rename your app with `heroku rename`)
* `git push heroku master`

