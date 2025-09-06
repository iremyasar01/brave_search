import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/presentations/browser/views/search_browser_screen.dart';
import 'package:brave_search/core/theme/theme_extensions.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
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
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Tema renklerini kullan, eğer yoksa yedek renkler kullan
    final backgroundColor = isDark
        ? colors?.bottomNavBackground ?? const Color(0xFF0A0A0A)
        : colors?.bottomNavBackground ?? const Color(0xFFF8F9FA);

    final textColor = isDark
        ? colors?.iconSecondary ?? Colors.white
        : colors?.textHint ?? Colors.black87;

    //final progressColor = colors?.accent ?? Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
             AssetConstants.constAnimation,
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
            FadeTransition(
              opacity: _animation,
              child: Text(
               AppConstant.braveSearchBrowser,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            /*
            // Yükleniyor İndikatörü 
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
            */
          ],
        ),
      ),
    );
  }
}
