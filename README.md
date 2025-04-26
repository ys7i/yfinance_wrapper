# YfinanceWrapper

YfinanceWrapper is a Ruby wrapper library for the Python yfinance library, which provides access to Yahoo Finance's API.

This library has the following features:

- Uses PyCall to make the Python yfinance library accessible from Ruby
- Simple and intuitive API
- Compatible with Ruby 3.0 and above

Main features:

- Stock information retrieval
- Stock price data retrieval
- Company information retrieval

This library supports the development of financial data applications and analysis tools by providing easy access to Yahoo Finance's data through Ruby.

# Installation

1. Install python3.
2. Install yfinance

```bash
pip3 install yfinance
```

# Example

```ruby
ticker = YfinanceWrapper::Ticker.new('APPL')
ticker.info
# {"quoteType"=>"MUTUALFUND",
#  "symbol"=>"APPL",
#  "language"=>"en-US"
# ...
# }

ticker.history(period: "max", interval: "1d")
# {1980-12-12 00:00:00 -0500=>
# ...
# }
```
