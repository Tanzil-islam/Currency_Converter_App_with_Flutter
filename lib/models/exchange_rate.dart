class ExchangeRate {
  final String base;
  final Map<String, double> rates;
  final int? timestamp; // Make this nullable
  final String timeLastUpdated;

  ExchangeRate({
    required this.base,
    required this.rates,
    this.timestamp, // No longer required since it's nullable
    required this.timeLastUpdated,
  });

  factory ExchangeRate.fromExchangeRateApiJson(Map<String, dynamic> json) {
    Map<String, dynamic> ratesJson = json['conversion_rates'];
    Map<String, double> ratesMap = {};

    ratesJson.forEach((key, value) {
      ratesMap[key] = value.toDouble();
    });

    return ExchangeRate(
      base: json['base_code'],
      rates: ratesMap,
      timestamp: json['time_last_update_unix'], // Use the correct field from the API
      timeLastUpdated: json['time_last_update_utc'],
    );
  }

  double getRate(String currencyCode) {
    if (currencyCode == base) return 1.0;
    return rates[currencyCode] ?? 0.0;
  }

  double convert(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    if (fromCurrency == base) {
      // Converting from base currency to another
      return amount * rates[toCurrency]!;
    } else if (toCurrency == base) {
      // Converting to base currency
      return amount / rates[fromCurrency]!;
    } else {
      // Cross-currency conversion
      double amountInBaseCurrency = amount / rates[fromCurrency]!;
      return amountInBaseCurrency * rates[toCurrency]!;
    }
  }
}