import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/theme.dart';

class InboxHeader extends StatelessWidget {
  final int total;
  final int unread;
  final bool isRefreshing;
  final String? errorText;
  final VoidCallback onRefresh;

  const InboxHeader({
    super.key,
    required this.total,
    required this.unread,
    required this.isRefreshing,
    required this.onRefresh,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget dot = Container(
      width: AppTheme.pulseDot,
      height: AppTheme.pulseDot,
      decoration:
          BoxDecoration(color: appColors.success, shape: BoxShape.circle),
    );
    if (!reduceMotion) {
      dot = dot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 0.3, end: 1, duration: 900.ms);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Inbox', style: text.headlineSmall),
            const SizedBox(width: AppTheme.spacingSm),
            if (unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: AppTheme.spacingXs),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text('$unread new',
                    style: text.labelMedium
                        ?.copyWith(color: theme.colorScheme.onPrimary)),
              ),
            const Spacer(),
            IconButton(
              tooltip: 'Refresh inbox',
              onPressed: isRefreshing ? null : onRefresh,
              icon: isRefreshing
                  ? const SizedBox.square(
                      dimension: AppTheme.iconSm,
                      child: CircularProgressIndicator(
                          strokeWidth: AppTheme.borderThick),
                    )
                  : const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        Row(
          children: [
            dot,
            const SizedBox(width: AppTheme.spacingSm),
            Flexible(
              child: Text(
                'Live · checking every 10 seconds · $total message${total == 1 ? '' : 's'}',
                style: text.bodySmall?.copyWith(color: appColors.subtleText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: appColors.danger.withValues(alpha: AppTheme.opacitySubtle),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(color: appColors.danger),
            ),
            child: Text(errorText!,
                style: text.bodySmall?.copyWith(color: appColors.danger)),
          ),
        ],
      ],
    );
  }
}
