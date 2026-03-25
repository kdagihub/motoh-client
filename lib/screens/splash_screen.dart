import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'auth/phone_screen.dart';
import 'home/home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goNext());
  }

  Future<void> _goNext() async {
    final auth = context.read<AuthProvider>();
    await auth.bootstrap();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final storage = context.read<StorageService>();
    final onboardingDone = await storage.isOnboardingComplete();
    if (!mounted) return;
    if (auth.isAuthenticated) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      return;
    }
    if (!onboardingDone) {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, PhoneScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(Icons.two_wheeler_rounded, size: 52, color: Colors.white),
            ),
            const SizedBox(height: 28),
            Text(
              'MotoH',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Votre moto-taxi, en un clin d’œil',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
