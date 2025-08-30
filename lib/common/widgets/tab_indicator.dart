import 'package:flutter/material.dart';


class TabIndicator extends StatelessWidget {
  final int index;
  final bool isActive;
  final int tabCount;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const TabIndicator({super.key, 
    required this.index,
    required this.isActive,
    required this.tabCount,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.web,
              size: 16,
              color: isActive ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              'Sekme ${index + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 12,
              ),
            ),
            if (tabCount > 1) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: isActive ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}