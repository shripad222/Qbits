import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelMapper;

  const AppDropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabelMapper,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      isExpanded: true,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemLabelMapper(item)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Please select a value' : null,
    );
  }
}