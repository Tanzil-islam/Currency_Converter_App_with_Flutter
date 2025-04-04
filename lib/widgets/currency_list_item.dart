import 'package:flutter/material.dart';
import 'package:currency_converter/models/currency.dart';

class CurrencyListItem extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const CurrencyListItem({
    Key? key,
    required this.currency,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        currency.code,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        currency.name,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isSelected 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: onTap,
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
    );
  }
}

class CurrencySearchDelegate extends SearchDelegate<String> {
  final Map<String, Currency> currencies;
  final String selectedCurrency;

  CurrencySearchDelegate({
    required this.currencies,
    required this.selectedCurrency,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, selectedCurrency);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = query.isEmpty
        ? currencies.values.toList()
        : currencies.values.where((currency) {
            return currency.code.toLowerCase().contains(query.toLowerCase()) ||
                currency.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

    // Sort results by code
    searchResults.sort((a, b) => a.code.compareTo(b.code));

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final currency = searchResults[index];
        final isSelected = currency.code == selectedCurrency;

        return CurrencyListItem(
          currency: currency,
          isSelected: isSelected,
          onTap: () {
            close(context, currency.code);
          },
        );
      },
    );
  }
}