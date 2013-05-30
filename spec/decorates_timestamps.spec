require 'spec_helper'

class Model
end

class Decorator < Draper::Base
  decorates :model
  extend DecoratesTimestamps
end

describe Decorator do
    
  describe ".decorates_timestamp" do

    let(:object) { Model.new }
    let(:decorator) { Decorator.new(object) }

    it "should respond to decorates_timestamp" do
      Decorator.should respond_to(:decorates_timestamp)
    end

    it "should define a method for the attribute" do
      Decorator.decorates_timestamp(:foo)
      decorator.should respond_to(:foo)
    end
  end

  describe ".decorates_timestamps" do
  
    it "should respond to decorates_timestamps" do
      Decorator.should respond_to(:decorates_timestamps)
    end

    it "should create decorator methods for each timestamp" do
      timestamp_symbols = [ :foo_at, :bar_on, :baz_at ]
      Model.class_eval { attr_reader *timestamp_symbols }
      Decorator.decorates_timestamps
      timestamp_symbols.each do |sym|
        Decorator.instance_methods(false).should include(sym)
      end
    end

  end

end
