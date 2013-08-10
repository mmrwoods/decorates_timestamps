require 'i18n'

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
      # FIXME: this is fscking horrible
      model_class_method = self.respond_to?(:model_class) ? :model_class : :object_class
      self.send(model_class_method).column_names.select{|name|
        name.match(/_(at|on)$/)
      }.map(&:to_sym)
    end
  end
end

module Draper
  # note: Draper::Base replaced with Draper::Decorator in v1.x
  ( defined?(Base) ? Base : Decorator ).extend(DecoratesTimestamps::ClassMethods)
end
