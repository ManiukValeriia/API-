require "net/http"
require "json"
require "csv"

API_KEY = "4a6059c28bf71dc0f46a0925"
BASE_CURRENCY = "USD"
TARGET_CURRENCIES = ["GBP", "EUR", "JPY"]

# Формування URI для запиту
uri = URI("https://v6.exchangerate-api.com/v6/#{API_KEY}/latest/#{BASE_CURRENCY}")
response = Net::HTTP.get(uri)
data = JSON.parse(response)

# Отримання курсів обміну
rates = data["conversion_rates"]

# Запис курсів у CSV файл
CSV.open("rates.csv", "w") do |csv|
  csv << ["Currency", "Rate"]

  TARGET_CURRENCIES.each do |currency|
    csv << [currency, rates[currency]]
  end
end

puts "Exchange rates successfully saved to rates.csv file."
