import 'package:flutter/material.dart';
import 'package:currency_converter/models/currency.dart';

class CurrencyDropdown extends StatelessWidget {
  final Map<String, Currency> currencies;
  final String selectedCurrency;
  final ValueChanged<String?> onChanged;
  
  const CurrencyDropdown({
    Key? key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort currencies by code
    List<Currency> sortedCurrencies = currencies.values.toList()
      ..sort((a, b) => a.code.compareTo(b.code));
      
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: currencies.containsKey(selectedCurrency) 
                ? selectedCurrency
                : null,
            isExpanded: true,
            hint: const Text('Select currency'),
            items: sortedCurrencies.map((Currency currency) {
              return DropdownMenuItem<String>(
                value: currency.code,
                child: Text(
                  '${currency.code} - ${currency.name}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ),
    );
  }
}