# IronHide::Storage::CouchdbAdapter

[![Gem Version](https://badge.fury.io/rb/iron_hide-storage-couchdb_adapter.svg)](http://badge.fury.io/rb/iron_hide-storage-couchdb_adapter)

A CouchDB adapter for the IronHide authorization library.

## Installation

Add this line to your application's Gemfile:

    gem 'iron_hide-storage-couchdb_adapter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iron_hide-storage-couchdb_adapter

## Setting up a CouchDB server

Assuming that you don't have a CouchDB server, this project comes with a few helper Rake tasks.

### Setup a local Couchdb server
The best resource for getting started with CouchDB is http://guide.couchdb.org/

Using brew:

```
brew install couchdb
couchdb # Starts the server
```


### Setup the server for use with IronHide
To install the helper Rake tasks:

```ruby
# Rakefile
require 'rake'
require 'iron_hide/couchdb_tasks'
```

To create a new database, either use the HTTP API, Futon, or this simple Rake task:

```
bundle exec rake iron_hide:create_db\['http://127.0.0.1:5984/rules'\]
```

To upload some rules to this database:

```
bundle exec rake iron_hide:load_rules\['/absolute/path/file.json','http://127.0.0.1:5984/rules'\]
```

Note: Required step
Setup the required views

```
bundle exec iron_hide:rake create_views\['http://127.0.0.1:5984/rules'\]
```

## Usage

```ruby
require 'iron_hide'
require 'iron_hide/storage/couchdb_adapter'

IronHide.config do |c|
    c.adapter          = :couchdb
    c.namespace        = 'TestApp'
    c.couchdb_server   = 'http://127.0.0.1:5984' # Default
    c.couchdb_database = 'rules' # Default
end
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/iron_hide-storage-couchdb_adapter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Further Reading
* [Tim Anglade](https://twitter.com/timanglade)
http://www.slideshare.net/timanglade/couchdb-ruby-youre-doing-it-wrong

## TODO
- Caching
- Tests
