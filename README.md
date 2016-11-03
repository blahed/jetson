# Jetson

Talk to JSON APIs in a convient ruby based console or use the DSL to make calls in your own code.

Jetson provides a simple wrapper for working with JSON APIs – it's built for working with JSON in a friendly and convient way and tries to simplify it to the point of not having to remember complex command line switches or configuration options.

*NOTE: Jetson is built to work with JSON APIs, if you need to work with APIs that aren't JSON based, this isn't the tool for you... sorry :(*

## Installation

```shell
$ gem install jetson
```

### Usage

You can work with Jetson in two different ways, the console or the DSL. The DSL actually powers the console, so you'll have a very similar experience regardless of what you choose to use based on your needs. The console is an IRB based environment for working with your API, and the DSL provides a set of methods that can be included in your own code or scripts.

## Console / REPL

To start the console, just run the jetson command with a hostname:

```shell
$ jetson localhost:3000
localhost:3000>
```

The console is actually powered by IRB, so you can do anything you'd do in IRB within the console... and command history works. HTTP verbs (get, post, put, patch, delete) are available as methods in the console:

```ruby
# GET request
localhost:3000> get '/foo'
# GET request with params
localhost:3000> get '/foo', {some: 'param'}
# POST with json payload
localhost:3000> post '/bar', {something: 'jsony'}
```

#### Cookies

Each console starts with a session (sorta like a browser), so any requests that set cookies will store those cookies and send them with subsequent requests. If you need to clear the cookies/session you can use the `clear :cookies` method.

#### Headers

Every request will have the `Content-Type` and `Accept` header set to `application/json`. If you need to add additional headers you can set them by manipulating the `headers` attribute:

```ruby
localhost:3000> headers[:some_header] = 'some value'
```

Headers set using the `headers` attribute will persist and be applied to every request made after, you can clear headers using the `clear :headers` method.


If you need to change headers on a per request basis, you can add a headers hash as the last argument to the request method:

```ruby
localhost:3000> post '/bar', {something: 'jsony'}, {some_header: 'some value'}
```


## DSL

The Jetson DSL is handy for writing scripts, once you include the DSL you'll get access to all of the methods that console has. The one difference is that you'll need to call your http methods inside a `session` block to set the host name. The session block also persists headers and cookies on a global level.

```ruby
require 'jetson/dsl'

extend Jetson::DSL

session 'http://localhost:4567' do
  set :verbose, true
  set :headers, {foo: 'bar'}
  set :cookies, {wee: 'hah'}
  
  get '/foo'
  
  res = get! ('/')
  
  puts res.status
end

```


#### Setting headers and cookies

While working within a `session` block you can use the `set` command to set headers or cookies. Both will be applied to ever request.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jetson.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

