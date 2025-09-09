import 'package:brave_search/common/constant/app_constant.dart';
import 'package:brave_search/common/constant/asset_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brave_search/core/network/cubit/network_cubit.dart';
import 'package:brave_search/presentations/browser/views/search_browser_screen.dart';
import 'package:brave_search/core/theme/theme_extensions.dart';
import 'package:brave_search/core/mixins/animation_mixin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, AnimationMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Animasyonu hemen başlat
    _controller.forward();

    // Ağ kontrolünü arka planda başlat (beklemeden)
    context.read<NetworkCubit>().checkConnection();
    
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Sadece minimum gösterim süresi (2 saniye) bekle
      await Future.delayed(const Duration(seconds: 3));
      
    
      // Navigasyon için kısa bir bekleme
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SearchBrowserScreen()),
        );
      }
    } catch (error) {
      // Hata durumunda da yine de ana ekrana yönlendir
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SearchBrowserScreen()),
        );
      }
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

    return Scaffold(
      backgroundColor: isDark
          ? colors?.bottomNavBackground ?? const Color(0xFF0A0A0A)
          : colors?.bottomNavBackground ?? const Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildControlledLottieAnimation(
              assetPath: AssetConstants.constAnimation,
              controller: _controller,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                AppConstant.braveSearchBrowser,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? colors?.iconSecondary ?? Colors.white
                      : colors?.textHint ?? Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}