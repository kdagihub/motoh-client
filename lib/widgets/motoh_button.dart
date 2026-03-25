import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MotohButton extends StatelessWidget {
  const MotohButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.style = MotohButtonStyle.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final MotohButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    final child = loading
        ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: style == MotohButtonStyle.primary ? Colors.white : AppColors.primary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22),
                const SizedBox(width: 10),
              ],
              Text(label),
            ],
          );

    switch (style) {
      case MotohButtonStyle.primary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          child: child,
        );
      case MotohButtonStyle.secondary:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            side: const BorderSide(color: AppColors.primary, width: 2),
            foregroundColor: AppColors.primary,
          ),
          child: child,
        );
      case MotohButtonStyle.ghost:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          child: child,
        );
    }
  }
}

enum MotohButtonStyle { primary, secondary, ghost }
