import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/motoh_button.dart';
import '../../widgets/motoh_text_field.dart';
import '../auth/phone_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final n = context.read<AuthProvider>().user?.clientProfile?.fullName ?? '';
      if (mounted && _name.text.isEmpty) {
        _name.text = n;
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final auth = context.read<AuthProvider>();
    auth.clearError();
    try {
      await auth.updateFullName(_name.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil enregistré')),
      );
    } catch (_) {
      if (!mounted) return;
      final msg = auth.error ?? 'Enregistrement impossible';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, PhoneScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final body = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (!widget.embedded) const SizedBox(height: 8),
          if (widget.embedded) ...[
            const SizedBox(height: 12),
            Text(
              'Mon profil',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Ce nom sera utilisé pour vous accueillir sur l’accueil.',
              style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 28),
          ],
          MotohTextField(
            controller: _name,
            label: 'Nom complet',
            hint: 'Ex. : Aya Koné',
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            validator: (v) {
              if (v == null || v.trim().length < 2) return 'Au moins 2 caractères';
              return null;
            },
          ),
          const SizedBox(height: 24),
          MotohButton(
            label: 'Enregistrer',
            loading: auth.loading,
            onPressed: auth.loading ? null : _save,
            icon: Icons.check_rounded,
          ),
          const SizedBox(height: 36),
          Text(
            'Compte',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (auth.user?.phone != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_rounded, color: AppColors.primary),
              title: const Text('Téléphone'),
              subtitle: Text(auth.user!.phone!),
            ),
          const SizedBox(height: 8),
          MotohButton(
            label: 'Se déconnecter',
            style: MotohButtonStyle.secondary,
            onPressed: _logout,
            icon: Icons.logout_rounded,
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return SafeArea(child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Mon profil')),
      body: SafeArea(child: body),
    );
  }
}
