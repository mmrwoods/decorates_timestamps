# decorates_timestamps

Convenience methods for decorating timestamps with draper.

https://github.com/thickpaddy/decorates_timestamps

## Description

Format timestamps consistently without modifying formatting constants
or calling localize multiple times with the same options, either in
your views (yuck), or in your decorators (better, but still yuck).

## Installation

Add to `Gemfile` and bundle install:

    $ echo "gem 'decorates_timestamps', :git => 'git://github.com/thickpaddy/decorates_timestamps.git'" >> Gemfile
    $ bundle install

## Usage

Best explained with an example...

    class MySuperDecorator < Draper::Base
      ...
      decorates_timestamps format: :long
      ...
    end

The above call to decorates_timestamps will decorate all timestamp
attribtues with the default timestamp decorator, whose #to_s method
simply localizes the value with the options provided.

And, that's about it right now, but there is lots to do...

## TODO

* Allow timestamps to be decorated with a custom timestamp decorator
* Allow the default timestamp decorator to be set by an initializer
* Allow decorates_timestamps to decorate only specified attributes
