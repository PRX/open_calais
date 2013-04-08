# OpenCalais

Ruby gem to access the OpenCalaid API, using the new-ish REST API, and JSON responses.
It uses Faraday to abstract HTTP library (defaults to use excon because ot is excellent), and multi_json to abstract JSON parsing.

It returns a parsed version of the response, but the response contains the raw response (converted from json to hashes/arrays/string/etc).

## Installation

Add this line to your application's Gemfile:

    gem 'open_calais'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_calais

## Usage

OpenCalais has one main method, 'enrich', and so does the gem:

    require 'open_calais'

    # you can configure for all calls
    OpenCalais.configure do |c|
      c.api_key = "this is a test key"
    end

    # or you can configure for a single call
    open_calais = OpenCalais::Client.new(:api_key=>'an api key')

    # it returns a OpenCalais::Response instance
    response = open_calais.enrich('Ruby on Rails is a fantastic web framework. It uses MVC, and the Ruby programming language invented by Matz in Japan.')

    # which has the 'raw' response
    response.raw

    # and has been parsed a bit to get :language, :topics, :tags, :entities, :relations, :locations
    # as lists of hashes
    response.tags.each{|t| puts t[:name] }


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
