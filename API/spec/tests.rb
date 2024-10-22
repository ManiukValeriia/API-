require "net/http"
require "json"
require "csv"
require "rspec"

API_KEY = "4a6059c28bf71dc0f46a0925"

def fetch_exchange_rates
  uri = URI("https://v6.exchangerate-api.com/v6/#{API_KEY}/latest/USD")
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

def save_to_csv(rates)
  currencies = ["USD", "GBP", "JPY"]

  CSV.open("rates.csv", "w") do |csv|
    csv << ["Currency", "Rate"]

    currencies.each do |currency|
      csv << [currency, rates[currency]]
    end
  end
end

RSpec.describe "Exchange Rate API" do
  before(:each) do
    @data = fetch_exchange_rates
    @rates = @data["conversion_rates"]
  end

  it "returns a successful response" do
    expect(@data["result"]).to eq("success")
  end

  it "contains exchange rates for USD, GBP, JPY" do
    expect(@rates).to have_key("USD")
    expect(@rates).to have_key("GBP")
    expect(@rates).to have_key("JPY")
  end

  it "saves exchange rates to a CSV file correctly" do
    save_to_csv(@rates)
    expect(File).to exist("rates.csv")

    csv_content = CSV.read("rates.csv")
    expect(csv_content[0]).to eq(["Currency", "Rate"])
    expect(csv_content[1]).to eq(["USD", @rates["USD"].to_s])
    expect(csv_content[2]).to eq(["GBP", @rates["GBP"].to_s])
    expect(csv_content[3]).to eq(["JPY", @rates["JPY"].to_s])
  end
end

# Виклик для запуску тестів
RSpec::Core::Runner.run([$__FILE__]) if __FILE__ == $0
