import 'package:flutter/material.dart';

import '../models/driver_info.dart';
import '../theme/app_colors.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.driver,
    required this.onTap,
  });

  final DriverInfo driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Avatar(driver: driver),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.defaultZone ?? driver.city,
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      driver.motorcyclePlate,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _OnlineBadge(online: driver.isOnline),
                  if (driver.distanceKm != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      '${driver.distanceKm!.toStringAsFixed(1)} km',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.driver});

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final url = driver.photo;
    final hasUrl = url != null && url.isNotEmpty;
    return CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.35),
      foregroundImage: hasUrl ? NetworkImage(url) : null,
      child: hasUrl
          ? null
          : Text(
              driver.initials,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
            ),
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge({required this.online});

  final bool online;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = online ? AppColors.success : AppColors.textSecondary;
    final label = online ? 'En ligne' : 'Hors ligne';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
