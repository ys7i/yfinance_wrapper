# frozen_string_literal: true

require "pycall/import"
require "date"
require "time"

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

    def news
      result = @ticker.news
      result.map { |v| v.to_h }
    end

    def basic_info
      result = @ticker.basic_info
      result.keys.each_with_object({}) do |key, hash|
        hash[key] = to_ruby_type(result[key])
      end
    end

    def calendar
      result = @ticker.calendar
      result.each_with_object({}) do |pair, hash|
        hash[pair[0]] = to_ruby_type(pair[1])
      end
    end

    def earnings = nil

    def isin
      @ticker.isin
    end

    def options
      @ticker.options.to_a
    end

    def fast_info
      result = @ticker.fast_info
      result.keys.each_with_object({}) do |key, hash|
        hash[key] = to_ruby_type(result[key])
      end
    end

    DF_METHODS = %i[actions balance_sheet capital_gains cash_flow cashflow dividends earnings_dates earnings_estimate
                    earnings_history eps_revisions eps_trend financials growth_estimates income_stmt incomestmt
                    insider_purchases insider_roster_holders insider_transactions institutional_holders major_holders
                    mutualfund_holders quarterly_balance_sheet quarterly_balancesheet quarterly_cash_flow quarterly_cashflow
                    quarterly_income_stmt quarterly_income_stmt quarterly_incomestmt recommendations recommendations_summary
                    splits sustainability ttm_cash_flow ttm_cashflow ttm_financials ttm_income_stmt ttm_incomestmt upgrades_downgrades]
    DICT_METHODS = %i[analyst_price_targets history_metadata quarterly_financials revenue_estimate]
    LIST_METHODS = %i[news sec_filings]

    UNIMPLEMENTED_METHODS = %i[funds_data quarterly_earnings]

    DF_METHODS.each do |method|
      define_method(method) do |*args, **kwargs|
        result = @ticker.send(method, *args, **kwargs)
        to_ruby_type(result)
      end
    end

    DICT_METHODS.each do |method|
      define_method(method) do |*args, **kwargs|
        result = @ticker.send(method, *args, **kwargs)
        to_ruby_type(result)
      end
    end

    UNIMPLEMENTED_METHODS.each do |method|
      define_method(method) do
        raise NotImplementedError, "Method #{method} is not implemented"
      end
    end

    LIST_METHODS.each do |method|
      define_method(method) do |*args, **kwargs|
        result = @ticker.send(method, *args, **kwargs)
        list_to_ruby_type(result)
      end
    end

    # private
    def list_to_ruby_type(list)
      list.map { |v| dict_to_ruby_type(v) }
    end

    def to_ruby_type(value)
      return dict_to_ruby_type(value) if value.class.to_s == "<class 'dict'>"

      return df_to_ruby_type(value) if value.respond_to?(:index) && value.respond_to?(:keys)

      case value.to_s
      when /\A-?\d+\.\d+\Z/
        value.to_f
      when /\A-?\d+\Z/
        value.to_i
      when /\A\[.+?\]\Z/
        if value.respond_to?(:map)
          value.map { |v| to_ruby_type(v) }
        else
          value.size.times.map { |i| to_ruby_type(value[i]) }
        end
      when /\A\d{4}-\d{2}-\d{2}\Z/
        date = value.to_s.scan(/\d+/).map(&:to_i)
        Date.new(date[0], date[1], date[2])
      when /\A\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\Z/
        Time.strptime(value.to_s, "%Y-%m-%d %H:%M:%S")
      when /\Anan\Z/, /\ANaN\Z/
        Float::NAN
      else
        value.to_s
      end
    end

    def df_to_ruby_type(df)
      indexes = df.index

      indexes.size.times.each_with_object({}) do |i, hash|
        index = indexes[i]
        ruby_index = to_ruby_type(indexes[i])
        value = df.loc[index]
        ruby_value = if value.respond_to?(:index) && value.respond_to?(:keys)
                       df_to_ruby_type(value)
                     else
                       to_ruby_type(value)
                     end

        hash[ruby_index] = ruby_value
      end
    end

    def dict_to_ruby_type(dict)
      if dict.respond_to?(:to_h)
        hash = dict.to_h
        hash.each_with_object({}) do |(key, value), hash|
          hash[key] = to_ruby_type(value)
        end
      elsif dict.respond_to?(:each_with_object)
        dict.each_with_object({}) do |(key, value), hash|
          hash[key] = to_ruby_type(value)
        end
        els
        dict.keys.each_with_object({}) do |key, hash|
          value = dict[key]
          hash[key] = to_ruby_type(value)
        end
      end
    end

    def candle_to_hash(candle, keys)
      keys.each_with_object({}) do |key, hash|
        hash[key] = candle[key].to_f
      end
    end
  end
end
