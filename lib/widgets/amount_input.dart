import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget {
  final double amount;
  final ValueChanged<double> onChanged;
  
  const AmountInput({
    Key? key,
    required this.amount,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = 
        TextEditingController(text: amount.toString());
    
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      onChanged: (value) {
        if (value.isNotEmpty) {
          try {
            final newAmount = double.parse(value);
            onChanged(newAmount);
          } catch (e) {
            // Invalid input, ignore
          }
        } else {
          onChanged(0);
        }
      },
    );
  }
}