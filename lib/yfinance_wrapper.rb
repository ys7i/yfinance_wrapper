# frozen_string_literal: true

require_relative "yfinance_wrapper/ticker"
include PyCall::Import
module YfinanceWrapper
  pyimport :yfinance, as: :yf
  # rubocop:disable Style/ClassVars
  @@yf = yf
  # rubocop:enable Style/ClassVars
end
