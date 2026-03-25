import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/driver_info.dart';
import '../../theme/app_colors.dart';
import '../../widgets/motoh_button.dart';

class DriverDetailScreen extends StatelessWidget {
  const DriverDetailScreen({super.key, required this.driver});

  static const String routeName = '/driver';

  final DriverInfo driver;

  Future<void> _call(BuildContext context) async {
    final raw = driver.phoneForContact;
    if (raw == null || raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro indisponible pour ce chauffeur')),
      );
      return;
    }
    final uri = Uri(scheme: 'tel', path: raw.replaceAll(' ', ''));
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir l’appel')),
        );
      }
    }
  }

  Future<void> _message(BuildContext context) async {
    final raw = driver.phoneForContact;
    if (raw == null || raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro indisponible pour la messagerie')),
      );
      return;
    }
    final body = Uri.encodeComponent('Bonjour, je vous contacte via MotoH.');
    final uri = Uri.parse('sms:${raw.replaceAll(' ', '')}?body=$body');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d’ouvrir les messages')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhoto = driver.photo != null && driver.photo!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                driver.fullName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: const [Shadow(blurRadius: 8, color: Colors.black45)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundImage: hasPhoto ? NetworkImage(driver.photo!) : null,
                      child: hasPhoto
                          ? null
                          : Text(
                              driver.initials,
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList.list(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (driver.isVerified)
                      Chip(
                        avatar: const Icon(Icons.verified_rounded, size: 18, color: AppColors.secondary),
                        label: const Text('Vérifié'),
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
                        side: BorderSide.none,
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    Chip(
                      avatar: Icon(
                        driver.isOnline ? Icons.circle : Icons.circle_outlined,
                        size: 14,
                        color: driver.isOnline ? AppColors.success : AppColors.textSecondary,
                      ),
                      label: Text(driver.isOnline ? 'En ligne' : 'Hors ligne'),
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _InfoRow(icon: Icons.location_city_rounded, label: 'Ville', value: driver.city),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.map_rounded,
                  label: 'Zone',
                  value: driver.defaultZone ?? '—',
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.confirmation_number_rounded,
                  label: 'Plaque',
                  value: driver.motorcyclePlate,
                ),
                if (driver.distanceKm != null) ...[
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.social_distance_rounded,
                    label: 'Distance',
                    value: '${driver.distanceKm!.toStringAsFixed(1)} km',
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: MotohButton(
                        label: 'Appeler',
                        icon: Icons.call_rounded,
                        onPressed: () => _call(context),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: MotohButton(
                        label: 'Message',
                        style: MotohButtonStyle.secondary,
                        icon: Icons.message_rounded,
                        onPressed: () => _message(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge?.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
