module DecoratesTimestamps
  def decorates_timestamp(timestamp_symbol)
    define_method(timestamp_symbol) do
    end
  end

  def decorates_timestamps
    timestamp_symbols.each{|sym| decorates_timestamp(sym) }
  end

  private
  def timestamp_symbols
    self.model_class.instance_methods(false).select{|sym|
      sym.to_s.match(/_(at|on)$/)
    }.map(&:to_sym)
  end
end
