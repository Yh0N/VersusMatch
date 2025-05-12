import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearchChanged;
  final String hintText;

  const SearchFilterBar({
    required this.controller,
    required this.onSearchChanged,
    this.hintText = 'Buscar...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
