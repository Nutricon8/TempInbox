import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class StateView extends StatelessWidget {
  final String title;
  final String message;
  final String? imageAsset;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateView({
    super.key,
    required this.title,
    required this.message,
    this.imageAsset,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageAsset != null)
            Image.asset(imageAsset!,
                height: AppTheme.illustrationSize, semanticLabel: title)
          else if (icon != null)
            Icon(icon, size: AppTheme.iconXl, color: appColors.danger),
          const SizedBox(height: AppTheme.spacingMd),
          Text(title,
              style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            message,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: appColors.subtleText),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppTheme.spacingLg),
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
