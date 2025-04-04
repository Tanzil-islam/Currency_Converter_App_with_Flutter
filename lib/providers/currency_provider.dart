import 'package:flutter/material.dart';
import 'package:currency_converter/models/currency.dart';
import 'package:currency_converter/models/exchange_rate.dart';
import 'package:currency_converter/services/currency_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();

  Map<String, Currency> _currencies = {};
  ExchangeRate? _exchangeRates;
  bool _isLoading = false;
  String _error = '';

  // Selected currencies
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amount = 1.0;
  double _convertedAmount = 0.0;

  // Getters
  Map<String, Currency> get currencies => _currencies;
  ExchangeRate? get exchangeRates => _exchangeRates;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  double get amount => _amount;
  double get convertedAmount => _convertedAmount;

  CurrencyProvider() {
    _loadSavedPreferences();
    fetchData();
  }

  // Load saved preferences
  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _fromCurrency = prefs.getString('fromCurrency') ?? 'USD';
    _toCurrency = prefs.getString('toCurrency') ?? 'EUR';
    notifyListeners();
  }

  // Save preferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fromCurrency', _fromCurrency);
    await prefs.setString('toCurrency', _toCurrency);
  }

  // Fetch currencies and exchange rates
  Future<void> fetchData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currencies = await _currencyService.fetchCurrencies();
      _exchangeRates = await _currencyService.fetchExchangeRates();
      if (_exchangeRates == null) {
        throw Exception('Failed to fetch exchange rates: Response was null');
      }
      _convertCurrency();
    } catch (e) {
      _error = 'Error fetching exchange rates: $e';
      print(_error); // Log the error for debugging
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set source currency
  void setFromCurrency(String currencyCode) {
    _fromCurrency = currencyCode;
    _savePreferences();
    _convertCurrency();
    notifyListeners();
  }

  // Set target currency
  void setToCurrency(String currencyCode) {
    _toCurrency = currencyCode;
    _savePreferences();
    _convertCurrency();
    notifyListeners();
  }

  // Set amount to convert
  void setAmount(double amount) {
    _amount = amount;
    _convertCurrency();
    notifyListeners();
  }

  // Swap currencies
  void swapCurrencies() {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;
    _savePreferences();
    _convertCurrency();
    notifyListeners();
  }

  // Convert currency
  void _convertCurrency() {
    if (_exchangeRates != null) {
      _convertedAmount = _currencyService.convertCurrency(
        _exchangeRates!,
        _amount,
        _fromCurrency,
        _toCurrency,
      );
    }
  }
}