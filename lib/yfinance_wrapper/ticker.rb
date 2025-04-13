# frozen_string_literal: true

require "pycall/import"

module YfinanceWrapper
  class Ticker
    def initialize(symbol)
      @ticker = YfinanceWrapper.yf.Ticker.new(symbol)
    end

    def info
      @ticker.info.to_h
    end

    def history(*args, **kwargs)
      result = @ticker.history(*args, **kwargs)
      indexes = result.index

      res = {}

      indexes.size.times do |i|
        key = indexes[i]
        res[Time.new(key.to_s)] = candle_to_hash(result.loc[key], %w[Open High Low Close])
      end

      res
    end

    private

    # Add Candle class when candle needs more mothods.
    def candle_to_hash(candle, keys)
      keys.each_with_object({}) do |key, hash|
        hash[key] = candle[key].to_f
      end
    end
  end
end
