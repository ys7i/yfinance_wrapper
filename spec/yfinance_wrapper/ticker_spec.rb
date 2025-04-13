# frozen_string_literal: true

require "yfinance_wrapper"

RSpec.describe YfinanceWrapper::Ticker do
  let(:symbol) { "AAPL" }
  let(:ticker) { described_class.new(symbol) }

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
end
