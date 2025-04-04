import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:currency_converter/providers/currency_provider.dart';
import 'package:currency_converter/widgets/amount_input.dart';
import 'package:currency_converter/widgets/currency_dropdown.dart';
import 'package:currency_converter/widgets/exchange_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        elevation: 0,
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.fetchData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Format date from timeLastUpdated
          String lastUpdated = 'Never';
          if (provider.exchangeRates != null) {
            lastUpdated = provider.exchangeRates!.timeLastUpdated;
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Last Updated: $lastUpdated',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AmountInput(
                  amount: provider.amount,
                  onChanged: (value) => provider.setAmount(value),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From'),
                          const SizedBox(height: 8),
                          CurrencyDropdown(
                            currencies: provider.currencies,
                            selectedCurrency: provider.fromCurrency,
                            onChanged: (value) =>
                                provider.setFromCurrency(value ?? 'USD'),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () => provider.swapCurrencies(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('To'),
                          const SizedBox(height: 8),
                          CurrencyDropdown(
                            currencies: provider.currencies,
                            selectedCurrency: provider.toCurrency,
                            onChanged: (value) =>
                                provider.setToCurrency(value ?? 'EUR'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ExchangeCard(
                  fromCurrency: provider.fromCurrency,
                  toCurrency: provider.toCurrency,
                  amount: provider.amount,
                  convertedAmount: provider.convertedAmount,
                  fromCurrencyName:
                      provider.currencies[provider.fromCurrency]?.name ?? '',
                  toCurrencyName:
                      provider.currencies[provider.toCurrency]?.name ?? '',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => provider.fetchData(),
                  child: const Text('Refresh Rates'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}