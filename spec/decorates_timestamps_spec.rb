require 'spec_helper'

module Draper
  describe "Base decorator" do
    # note: Draper::Base replaced with Draper::Decorator in v1.x
    subject { defined?(Base) ? Base : Decorator }

    it "should respond to decorates_timestamp" do
      subject.should respond_to(:decorates_timestamp)
    end

    it "should respond to decorates_timestamps" do
      subject.should respond_to(:decorates_timestamps)
    end
  end
end

module DecoratesTimestamps
  describe I18nTimestampDecorator do
    describe "#to_s" do

      before(:all) do
        @value = Time.now
        @options = {:foo => :bar}
        @decorator = I18nTimestampDecorator.new(@value, @options)
      end

      it "should localize the input" do
        I18n.should_receive(:localize).with(@value, anything)
        @decorator.to_s
      end

      it "should pass any provided options to I18n.localize" do
        I18n.should_receive(:localize).with(@value, @options)
        @decorator.to_s
      end
    end
  end
end

describe TestDecorator do

  describe ".decorates_timestamp" do

    let(:object) { TestModel.new }
    let(:decorator) { TestDecorator.new(object) }

    it "should define a decorator method for the attribute" do
      TestDecorator.decorates_timestamp(:foo)
      decorator.should respond_to(:foo)
    end

    describe "decorator method" do

      context "when source attribute value is nil" do
        before(:all) do
          TestModel.class_eval { def foo; nil; end}
        end

        it "should return nil" do
          decorator.foo.should == nil
        end
      end

      context "when source attribute has some value" do
        before(:all) do
          TestModel.class_eval { def foo; "foo"; end}
          @default_decorator = DecoratesTimestamps.default_timestamp_decorator
        end

        it "should decorate the value with the default decorator" do
          @default_decorator.should_receive(:new).with("foo", anything)
          decorator.foo
        end

        it "should return an instance of the default decorator" do
          decorator.foo.class.should == @default_decorator
        end

        context "and options were provided when creating the method" do
          it "should provide the same options to the decorator" do
            options = {:bar => :baz}
            TestDecorator.decorates_timestamp(:foo, options)
            @default_decorator.should_receive(:new).with("foo", options)
            decorator.foo
          end
        end
      end

    end

  end

  describe ".decorates_timestamps" do

    before(:all) do
      @timestamp_symbols = TestModel.column_names.select{|name|
        name.match(/_(at|on)$/)
      }
    end

    it "should call decorates_timestamp for each timestamp" do
      @timestamp_symbols.each do |sym|
        TestDecorator.should_receive(:decorates_timestamp).with(sym, anything)
      end
      TestDecorator.decorates_timestamps
    end

    context "with an options argument" do
      it "should provide the options to decorates_timestamp" do
        options = {:bar => :baz}
        @timestamp_symbols.each do |sym|
          TestDecorator.should_receive(:decorates_timestamp).with(sym, options)
        end
        TestDecorator.decorates_timestamps(options)
      end
    end

  end

end
