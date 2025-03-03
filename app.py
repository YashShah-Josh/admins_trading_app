
from alpha_vantage.timeseries import TimeSeries
import pandas as pd

# Get a free API key from https://www.alphavantage.co/support/#api-key
API_KEY = "2B5DVWWUWFY4CIR2"

ts = TimeSeries(key=API_KEY, output_format="pandas")

# Fetch historical data for TCS
symbol = "ICICIBANK.BSE"  # Use ".BSE" for Bombay Stock Exchange

data, meta_data = ts.get_daily(symbol=symbol, outputsize="full")

# Save to CSV
data.to_csv("alpha_vantage_icici.csv")

print("✅ Historical data saved from Alpha Vantage.")


