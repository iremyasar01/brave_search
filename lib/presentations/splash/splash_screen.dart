import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/presentations/browser/views/search_browser_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    
    // Uygulama başlangıç işlemleri ve yönlendirme
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Gerekli başlangıç kontrolleri
    await context.read<NetworkCubit>().checkConnection();
    
    // Animasyon süresini bekleyip ana ekrana geç
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SearchBrowserScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animasyonu
            Lottie.asset(
              'assets/animations/Web Search..json',
              width: 200,
              height: 200,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Uygulama Adı
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Brave Search Browser',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Yükleniyor İndikatörü
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}