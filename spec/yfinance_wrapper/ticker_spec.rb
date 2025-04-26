# frozen_string_literal: true

require "yfinance_wrapper"

RSpec.describe YfinanceWrapper::Ticker do
  let(:symbol) { "AAPL" }
  let(:ticker) { described_class.new(symbol) }

  shared_examples "an array returning method" do |method_name|
    describe "##{method_name}" do
      it "returns an array" do
        result = ticker.send(method_name)
        expect(result).to be_a(Array)
      end
    end
  end

  describe "#info" do
    it "returns stock info" do
      info = ticker.info
      expect(info).to be_a(Hash)
      expect(info["symbol"]).to eq(symbol)
    end
  end

  describe "#history" do
    it "returns stock history" do
      history = ticker.history(period: "1d", interval: "1m")
      expect(history).to be_a(Hash)
      expect(history.keys.first).to be_a(Time)
      expect(history.values.first).to be_a(Hash)
      expect(history.values.first.keys).to include("Open", "High", "Low", "Close")
    end
  end

  describe "#news" do
    it "returns stock news" do
      news = ticker.news
      expect(news).to be_a(Array)
      expect(news.first).to be_a(Hash)
    end
  end

  describe "#basic_info" do
    it "returns stock basic info" do
      basic_info = ticker.basic_info
      expect(basic_info).to be_a(Hash)
    end
  end

  describe "#calendar" do
    it "returns stock calendar" do
      calendar = ticker.calendar
      expect(calendar).to be_a(Hash)
    end
  end

  describe "#earnings" do
    it "returns nil" do
      earnings = ticker.earnings
      expect(earnings).to be_nil
    end
  end

  describe "#isin" do
    it "returns stock isin" do
      isin = ticker.isin
      expect(isin).to eq("US0378331005")
    end
  end

  describe "#options" do
    it "returns stock options" do
      options = ticker.options
      expect(options).to be_a(Array)
      expect(options.first).to be_a(String)
    end
  end

  describe "#fast_info" do
    it "returns stock fast info" do
      fast_info = ticker.fast_info
      expect(fast_info).to be_a(Hash)
    end
  end

  describe "DF_METHODS" do
    it "returns stock data as hash" do
      YfinanceWrapper::Ticker::DF_METHODS.each do |method|
        result = ticker.send(method)
        expect(result).to be_a(Hash), "Method #{method} should return a hash"
      rescue StandardError => e
        puts "#{method} failed: #{e.message}"
        raise e
      end
    end
  end

  describe "DICT_METHODS" do
    it "returns stock data as hash" do
      YfinanceWrapper::Ticker::DICT_METHODS.each do |method|
        result = ticker.send(method)
        expect(result).to be_a(Hash), "Method #{method} should return a hash"
      rescue StandardError => e
        puts "#{method} failed: #{e.message}"
        raise e
      end
    end
  end

  describe "LIST_METHODS" do
    it "returns stock data as array" do
      YfinanceWrapper::Ticker::LIST_METHODS.each do |method|
        result = ticker.send(method)
        expect(result).to be_a(Array), "Method #{method} should return an array"
      end
    end
  end
end
