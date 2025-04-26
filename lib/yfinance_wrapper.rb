# frozen_string_literal: true

require_relative "yfinance_wrapper/ticker"
# rubocop:disable Style/MixinUsage
include PyCall::Import
# rubocop:enable Style/MixinUsage

module YfinanceWrapper
  pyimport :yfinance, as: :yf
  # rubocop:disable Style/ClassVars
  @@yf = yf
  # rubocop:enable Style/ClassVars
end
