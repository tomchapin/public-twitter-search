# Public Twitter Search
This is a very light-weight app that allows you to search Twitter's publicly visible tweets,
without needing an API key.

It runs on Rack/Sinatra and uses the REST-client and Nokogiri gems to search Twitter and parse
the HTML response page, converting the page of results into a JSON object.

## Usage:

1. Install dependencies, using ```bundle install```
2. Run the app, using ```rackup config.ru```
3. GET the Twitter search JSON endpoint:

```
http://localhost:9292/search.json?query=foo
```

## Deployment

This app is ready for deployment to [Heroku](http://heroku.com).

* Create an acount in seconds at [Heroku](http://heroku.com/signup).
* Install the gem `sudo gem install heroku`.
* If you do not have an SSH key
you'll need to [generate
one](http://heroku.com/docs/index.html#_setting_up_ssh_public_keys)
and [tell Heroku about
it](http://heroku.com/docs/index.html#_manage_keys_on_heroku)
* Clone this repo `git clone git://github.com/sinatra/heroku-sinatra-app [appname]`
* `cd /path/to/project`
* `heroku create [optional-app-name]` (You can rename your app with `heroku rename`)
* `git push heroku master`

