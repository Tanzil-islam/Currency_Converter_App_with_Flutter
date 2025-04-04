import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_converter/providers/currency_provider.dart';
import 'package:currency_converter/widgets/currency_list_item.dart';
import 'package:intl/intl.dart';
import 'package:currency_converter/utils/helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  String _decimalDigits = '2';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
      _decimalDigits = prefs.getString('decimalDigits') ?? '2';
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('useSystemTheme', _useSystemTheme);
    await prefs.setString('decimalDigits', _decimalDigits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<CurrencyProvider>(
              builder: (context, provider, _) {
                // Get last updated time from provider
                String lastUpdated = 'Never';
                if (provider.exchangeRates != null) {
                  lastUpdated = provider.exchangeRates!.timeLastUpdated;
                }

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    _buildSection(
                      title: 'App Theme',
                      children: [
                        SwitchListTile(
                          title: const Text('Use System Theme'),
                          subtitle: const Text(
                            'Automatically match your device theme',
                          ),
                          value: _useSystemTheme,
                          onChanged: (value) {
                            setState(() {
                              _useSystemTheme = value;
                            });
                            _saveSettings();
                          },
                        ),
                        if (!_useSystemTheme)
                          SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: const Text(
                              'Enable dark theme for the app',
                            ),
                            value: _isDarkMode,
                            onChanged: (value) {
                              setState(() {
                                _isDarkMode = value;
                              });
                              _saveSettings();
                            },
                          ),
                      ],
                    ),
                    _buildSection(
                      title: 'Display Options',
                      children: [
                        ListTile(
                          title: const Text('Decimal Digits'),
                          subtitle: const Text(
                            'Number of decimal places to show',
                          ),
                          trailing: DropdownButton<String>(
                            value: _decimalDigits,
                            items: const [
                              DropdownMenuItem(
                                value: '0',
                                child: Text('0'),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text('2'),
                              ),
                              DropdownMenuItem(
                                value: '4',
                                child: Text('4'),
                              ),
                              DropdownMenuItem(
                                value: '6',
                                child: Text('6'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _decimalDigits = value;
                                });
                                _saveSettings();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    _buildSection(
                      title: 'Default Currencies',
                      children: [
                        ListTile(
                          title: const Text('From Currency'),
                          subtitle: Text(
                            provider.currencies[provider.fromCurrency]?.name ??
                                '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            provider.fromCurrency,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            // Show currency search
                            final result = await showSearch<String>(
                              context: context,
                              delegate: CurrencySearchDelegate(
                                currencies: provider.currencies,
                                selectedCurrency: provider.fromCurrency,
                              ),
                            );
                            if (result != null) {
                              provider.setFromCurrency(result);
                            }
                          },
                        ),
                        ListTile(
                          title: const Text('To Currency'),
                          subtitle: Text(
                            provider.currencies[provider.toCurrency]?.name ??
                                '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            provider.toCurrency,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            // Show currency search
                            final result = await showSearch<String>(
                              context: context,
                              delegate: CurrencySearchDelegate(
                                currencies: provider.currencies,
                                selectedCurrency: provider.toCurrency,
                              ),
                            );
                            if (result != null) {
                              provider.setToCurrency(result);
                            }
                          },
                        ),
                      ],
                    ),
                    _buildSection(
                      title: 'Data',
                      children: [
                        ListTile(
                          title: const Text('Last Updated'),
                          subtitle: Text(lastUpdated),
                          trailing: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              provider.fetchData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Refreshing exchange rates...'),
                                ),
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Data Source'),
                          subtitle: const Text('ExchangeRate-API'),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () {
                            _showApiInfoDialog(context);
                          },
                        ),
                      ],
                    ),
                    _buildSection(
                      title: 'About',
                      children: [
                        const ListTile(
                          title: Text('Version'),
                          subtitle: Text('1.0.0'),
                        ),
                        ListTile(
                          title: const Text('Privacy Policy'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to privacy policy
                          },
                        ),
                        ListTile(
                          title: const Text('Terms of Service'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // Navigate to terms
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showApiInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Source Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This app uses the ExchangeRate-API to provide currency conversion data.',
            ),
            SizedBox(height: 16),
            Text(
              'Exchange rates are updated daily and reflect global market values.',
            ),
            SizedBox(height: 16),
            Text(
              'Note: The free tier of ExchangeRate-API only provides limited base currencies for conversions.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}