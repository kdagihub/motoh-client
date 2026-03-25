import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';

class OtpRouteArgs {
  OtpRouteArgs({required this.userId, required this.phoneDisplay});

  final String userId;
  final String phoneDisplay;
}

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.userId, required this.phoneDisplay});

  static const String routeName = '/auth/otp';

  final String userId;
  final String phoneDisplay;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';

  Future<void> _verify() async {
    if (_code.length != 6) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();
    try {
      await auth.verifyOtp(userId: widget.userId, code: _code);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    } catch (_) {
      if (!mounted) return;
      final msg = auth.error ?? 'Code incorrect';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Code de vérification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Saisissez le code reçu',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Envoyé au ${widget.phoneDisplay}',
                style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 36),
              MaterialPinField(
                length: 6,
                autoFocus: true,
                keyboardType: TextInputType.number,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(48, 56),
                  spacing: 8,
                  borderRadius: BorderRadius.circular(12),
                  borderColor: AppColors.textSecondary.withValues(alpha: 0.35),
                  focusedBorderColor: AppColors.primary,
                  fillColor: AppColors.surface,
                  cursorColor: AppColors.primary,
                  textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                onChanged: (v) => setState(() => _code = v),
                onCompleted: (v) {
                  setState(() => _code = v);
                  _verify();
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.loading || _code.length != 6 ? null : _verify,
                  child: auth.loading
                      ? const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Valider'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
