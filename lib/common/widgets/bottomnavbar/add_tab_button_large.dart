import 'package:brave_search/common/constant/app_constant.dart';
import 'package:flutter/material.dart';

class AddTabButtonLarge extends StatelessWidget {
  final VoidCallback onAddTab;
  final bool closeModal;

  const AddTabButtonLarge({
    super.key, 
    required this.onAddTab,
    this.closeModal = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.icon(
      onPressed: () {
        onAddTab();
        if (closeModal) {
          Navigator.pop(context);
        }
      },
      icon: const Icon(Icons.add),
      label: const Text(TabStrings.newTab),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}