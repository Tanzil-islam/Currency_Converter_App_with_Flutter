import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Get API key from environment variables
  static String apiKey = dotenv.env['EXCHANGE_RATE_API_KEY'] ?? '';
  
  // Base URL for Exchange Rate API
  static const String baseUrl = 'https://v6.exchangerate-api.com/v6';
  
  // Endpoints
  static const String latestRatesEndpoint = '/latest';
  static const String currenciesEndpoint = '/codes';
  
  // Full URL for latest rates
  static String getLatestRatesUrl(String baseCurrency) => 
      '$baseUrl/$apiKey$latestRatesEndpoint/$baseCurrency';
  
  // Full URL for currencies list
  static String getCurrenciesUrl() => 
      '$baseUrl/$apiKey$currenciesEndpoint';
}