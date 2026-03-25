import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'auth/phone_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardPageData(
      icon: Icons.visibility_rounded,
      title: 'Repérez les motos près de vous',
      body:
          'MotoH vous aide à voir les chauffeurs disponibles autour de vous, triés par distance, pour gagner du temps à Abidjan et ailleurs.',
      accent: AppColors.primary,
    ),
    _OnboardPageData(
      icon: Icons.phone_in_talk_rounded,
      title: 'Contact direct',
      body:
          'Appelez ou envoyez un message au chauffeur choisi. Simple, rapide, sans intermédiaire inutile.',
      accent: AppColors.secondary,
    ),
    _OnboardPageData(
      icon: Icons.verified_user_rounded,
      title: 'Profil et confiance',
      body:
          'Gérez votre nom affiché et retrouvez les infos utiles : plaque, zone, statut en ligne — pour voyager l’esprit tranquille.',
      accent: AppColors.warning,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<StorageService>().setOnboardingComplete(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, PhoneScreen.routeName);
  }

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _finish,
            child: const Text('Passer'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: p.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Icon(p.icon, size: 56, color: p.accent),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _index == i ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _index == i ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_index < _pages.length - 1 ? 'Continuer' : 'Commencer'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageData {
  const _OnboardPageData({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
}
