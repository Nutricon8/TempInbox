import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class AddressCard extends StatelessWidget {
  final String? address;
  final bool isCreating;
  final VoidCallback onCopy;
  final VoidCallback onNewAddress;

  const AddressCard({
    super.key,
    required this.address,
    required this.isCreating,
    required this.onCopy,
    required this.onNewAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final onHero = appColors.onHero;
    final ready = address != null && !isCreating;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appColors.heroStart, appColors.heroEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: appColors.heroEnd.withValues(alpha: AppTheme.opacityGlow),
            blurRadius: AppTheme.shadowBlur,
            offset: const Offset(0, AppTheme.spacingSm),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -AppTheme.spacingXl,
            top: -AppTheme.spacingXl,
            child: Container(
              width: AppTheme.decorCircle,
              height: AppTheme.decorCircle,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: onHero.withValues(alpha: AppTheme.opacitySubtle),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_moon_outlined,
                        color: onHero, size: AppTheme.iconSm),
                    const SizedBox(width: AppTheme.spacingSm),
                    Flexible(
                      child: Text(
                        'Your temporary address',
                        style: text.labelLarge?.copyWith(
                          color: onHero.withValues(alpha: AppTheme.opacityHint),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: ready
                      ? SelectableText(
                          address!,
                          key: ValueKey(address),
                          style: text.headlineSmall?.copyWith(color: onHero),
                          maxLines: 2,
                        )
                      : Column(
                          key: const ValueKey('loading'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Generating a fresh address…',
                                style:
                                    text.titleMedium?.copyWith(color: onHero)),
                            const SizedBox(height: AppTheme.spacingSm),
                            LinearProgressIndicator(
                              color: onHero,
                              backgroundColor: onHero.withValues(
                                  alpha: AppTheme.opacityGlass),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AppTheme.spacingLg),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: ready ? onCopy : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: onHero,
                          foregroundColor: appColors.heroStart,
                        ),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Copy'),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isCreating ? null : onNewAddress,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: onHero,
                          side: BorderSide(
                              color: onHero.withValues(
                                  alpha: AppTheme.opacityHint)),
                        ),
                        icon: const Icon(Icons.autorenew_rounded),
                        label: const Text('New'),
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
