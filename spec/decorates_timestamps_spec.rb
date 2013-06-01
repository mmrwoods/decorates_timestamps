require 'spec_helper'

module Draper

  # note: Draper::Base replaced with Draper::Decorator in v1.x
  base_decorator = defined?(Base) ? Base : Decorator

  describe base_decorator do

    subject { base_decorator  }

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

    let(:value) { "foo" }
    let(:options) { {bar: :baz} }

    subject { I18nTimestampDecorator.new(value, options) }

    describe "#to_s" do
      it "should localize the input" do
        I18n.should_receive(:localize).with(value, anything)
        subject.to_s
      end

      it "should pass any provided options to I18n.localize" do
        I18n.should_receive(:localize).with(value, options)
        subject.to_s
      end
    end

  end

  describe ClassMethods do

    subject { TestDecorator.new(TestModel.new) }

    describe ".decorates_timestamp" do

      it "should define a decorator method for the attribute" do
        TestDecorator.decorates_timestamp(:foo)
        subject.should respond_to(:foo)
      end

      describe "decorator method" do

        context "when source attribute value is nil" do
          before(:all) do
            TestModel.class_eval { def foo; nil; end}
          end

          it "should return nil" do
            subject.foo.should == nil
          end
        end

        context "when source attribute has some value" do

          let(:default_timestamp_decorator) {
            DecoratesTimestamps.default_timestamp_decorator
          }

          before(:all) do
            TestModel.class_eval { def foo; "foo"; end}
          end

          it "should decorate the value with the default decorator" do
            default_timestamp_decorator.should_receive(:new).with("foo", anything)
            subject.foo
          end

          it "should return an instance of the default decorator" do
            subject.foo.class.should == default_timestamp_decorator
          end

          context "and options were provided when creating the method" do
            it "should provide the same options to the decorator" do
              options = {:bar => :baz}
              TestDecorator.decorates_timestamp(:foo, options)
              default_timestamp_decorator.should_receive(:new).with("foo", options)
              subject.foo
            end
          end

        end

      end

    end

    describe ".decorates_timestamps" do

      let(:timestamp_symbols) {
        TestModel.column_names.select{|name| name.match(/_(at|on)$/) }
      }

      it "should call decorates_timestamp for each timestamp" do
        timestamp_symbols.each do |sym|
          TestDecorator.should_receive(:decorates_timestamp).with(sym, anything)
        end
        TestDecorator.decorates_timestamps
      end

      context "with an options argument" do

        let(:options) { {bar: :baz} }

        it "should provide the options to decorates_timestamp" do
          timestamp_symbols.each do |sym|
            TestDecorator.should_receive(:decorates_timestamp).with(sym, options)
          end
          TestDecorator.decorates_timestamps(options)
        end

      end

    end

  end

end
