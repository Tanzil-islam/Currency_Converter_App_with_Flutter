class AppConstants {
  // App name
  static const String appName = 'Currency Converter';
  
  // Shared preferences keys
  static const String prefFromCurrency = 'fromCurrency';
  static const String prefToCurrency = 'toCurrency';
  
  // Default values
  static const String defaultFromCurrency = 'USD';
  static const String defaultToCurrency = 'EUR';
  static const double defaultAmount = 1.0;
  
  // Refresh interval in milliseconds (e.g., 1 hour)
  static const int ratesRefreshInterval = 60 * 60 * 1000;
}