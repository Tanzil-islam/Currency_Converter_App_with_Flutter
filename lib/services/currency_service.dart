import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:currency_converter/config/api_config.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/models/exchange_rate.dart';

class CurrencyService {
  // Fetch all available currencies
  Future<Map<String, Currency>> fetchCurrencies() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getCurrenciesUrl()));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['result'] == 'success') {
          List<dynamic> currencyCodes = data['supported_codes'];
          Map<String, Currency> currencies = {};
          
          for (var currency in currencyCodes) {
            // Each entry is [code, name]
            currencies[currency[0]] = Currency(
              code: currency[0],
              name: currency[1],
            );
          }
          
          return currencies;
        } else {
          throw Exception('API Error: ${data['error-type']}');
        }
      } else {
        throw Exception('Failed to load currencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }
  
  // Fetch latest exchange rates
  Future<ExchangeRate> fetchExchangeRates({String baseCurrency = 'USD'}) async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getLatestRatesUrl(baseCurrency)));
      
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        
        if (data['result'] == 'success') {
          return ExchangeRate.fromExchangeRateApiJson(data);
        } else {
          throw Exception('API Error: ${data['error-type']}');
        }
      } else {
        throw Exception('Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }
  
  // Convert currency amount
  double convertCurrency(
    ExchangeRate rates,
    double amount,
    String fromCurrency,
    String toCurrency,
  ) {
    if (fromCurrency == rates.base) {
      // Direct conversion from base currency
      return amount * (rates.rates[toCurrency] ?? 1.0);
    } else if (toCurrency == rates.base) {
      // Direct conversion to base currency
      return amount / (rates.rates[fromCurrency] ?? 1.0);
    } else {
      // Cross conversion: first to base currency, then to target currency
      double amountInBaseCurrency = amount / (rates.rates[fromCurrency] ?? 1.0);
      return amountInBaseCurrency * (rates.rates[toCurrency] ?? 1.0);
    }
  }
}