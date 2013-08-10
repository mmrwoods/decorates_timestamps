require 'rspec'
require 'draper'
require 'active_record'
require 'nulldb/core'
require_relative '../lib/decorates_timestamps'

ActiveRecord::Base.establish_connection :adapter => :nulldb

ActiveRecord::Base.connection.create_table "test" do |t|
  t.datetime "foo_at"
  t.date "bar_on"
  t.timestamp "baz_at"
end

class TestModel < ActiveRecord::Base
  table_name = :test
end

class TestDecorator < ( defined?(Draper::Base) ? Draper::Base : Draper::Decorator )
  decorates :test_model
  delegate_all if self.respond_to?(:delegate_all)
end
