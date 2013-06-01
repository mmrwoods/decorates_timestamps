require 'i18n'

# TODO:
# * Allow timestamps to be decorated with a custom decorator
# * Allow default timestamp decorator to be set by an initializer
# * Allow decorates_timestamps to decorate only specified attributes
# * Review mechanism for adding class methods to base draper decorator
# * Test with draper v1.x (should work, but needs to be tested)

module DecoratesTimestamps
  class << self
    def default_timestamp_decorator
      I18nTimestampDecorator
    end
  end

  class I18nTimestampDecorator
    def initialize(input, options={})
      @object = input
      @options = options
    end

    def to_s
      I18n.localize(@object, @options)
    end
  end

  module ClassMethods
    def decorates_timestamp(timestamp_symbol, options={})
      define_method(timestamp_symbol) do
        attribute_value = model.send(timestamp_symbol)
        return if attribute_value.nil?
        DecoratesTimestamps.default_timestamp_decorator.new(attribute_value, options)
      end
    end

    def decorates_timestamps(options={})
      timestamp_symbols.each{|sym| decorates_timestamp(sym, options) }
    end

    private
    def timestamp_symbols
      self.model_class.column_names.select{|name|
        name.match(/_(at|on)$/)
      }.map(&:to_sym)
    end
  end
end

module Draper
  # note: Draper::Base replaced with Draper::Decorator in v1.x
  ( defined?(Base) ? Base : Decorator ).extend(DecoratesTimestamps::ClassMethods)
end
