import 'package:flutter/material.dart';

class EmptyBrowserState extends StatelessWidget {
  const EmptyBrowserState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // DuckDuckGo Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: const Center(
              child: Text(
                '🦆',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // DuckDuckGo Yazısı
          const Text(
            'DuckDuckGo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Alt yazı
          const Text(
            'Gizliliğinizi koruyarak arama yapın',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}