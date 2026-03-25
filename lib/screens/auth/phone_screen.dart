import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/motoh_button.dart';
import '../../widgets/motoh_text_field.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  static const String routeName = '/auth/phone';

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String? _normalizeToE164(String input) {
    var s = input.replaceAll(RegExp(r'\s'), '');
    if (s.isEmpty) return null;
    if (s.startsWith('+225')) {
      final rest = s.substring(4);
      if (!RegExp(r'^\d{10}$').hasMatch(rest)) return null;
      return '+225$rest';
    }
    if (s.startsWith('225') && s.length == 13) {
      return '+$s';
    }
    if (s.startsWith('0') && s.length == 10) {
      return '+225${s.substring(1)}';
    }
    if (RegExp(r'^\d{10}$').hasMatch(s)) {
      return '+225$s';
    }
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final e164 = _normalizeToE164(_phone.text.trim());
    if (e164 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro invalide. Ex. : 07 12 34 56 78')),
      );
      return;
    }
    final auth = context.read<AuthProvider>();
    auth.clearError();
    try {
      final r = await auth.requestOtp(e164);
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        OtpScreen.routeName,
        arguments: OtpRouteArgs(userId: r.userId, phoneDisplay: e164),
      );
    } catch (_) {
      if (!mounted) return;
      final msg = auth.error ?? 'Impossible d’envoyer le code';
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
        title: const Text('Connexion'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Entrez votre numéro',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  'Nous vous enverrons un code par SMS pour vérifier votre compte.',
                  style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 32),
                MotohTextField(
                  controller: _phone,
                  label: 'Numéro de téléphone',
                  hint: '07 12 34 56 78',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  prefix: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Champ requis';
                    if (_normalizeToE164(v.trim()) == null) {
                      return 'Format attendu : 10 chiffres (ex. 07…)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                MotohButton(
                  label: 'Recevoir le code',
                  loading: auth.loading,
                  onPressed: auth.loading ? null : _submit,
                  icon: Icons.sms_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
