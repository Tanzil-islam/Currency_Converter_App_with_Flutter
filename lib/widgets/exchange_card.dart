import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExchangeCard extends StatelessWidget {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final String fromCurrencyName;
  final String toCurrencyName;
  
  const ExchangeCard({
    Key? key,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.fromCurrencyName,
    required this.toCurrencyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create currency formatters
    final fromFormat = NumberFormat.currency(
      symbol: fromCurrency,
      decimalDigits: 2,
    );
    
    final toFormat = NumberFormat.currency(
      symbol: toCurrency,
      decimalDigits: 2,
    );
    
    // Calculate exchange rate
    final rate = amount != 0 ? convertedAmount / amount : 0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fromFormat.format(amount),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Icon(Icons.arrow_forward),
                Text(
                  toFormat.format(convertedAmount),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Exchange Rate: 1 $fromCurrency = ${rate.toStringAsFixed(6)} $toCurrency',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    fromCurrencyName,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    toCurrencyName,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}