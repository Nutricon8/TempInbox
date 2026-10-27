import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/mail_message.dart';
import '../../theme/theme.dart';
import '../common/sender_avatar.dart';

class MessageTile extends StatelessWidget {
  final MailMessage message;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MessageTile({
    super.key,
    required this.message,
    required this.onTap,
    required this.onDelete,
  });

  String _time(DateTime t) {
    final now = DateTime.now();
    final sameDay =
        t.year == now.year && t.month == now.month && t.day == now.day;
    return sameDay ? DateFormat.jm().format(t) : DateFormat.MMMd().format(t);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final unread = !message.seen;
    final radius = BorderRadius.circular(AppTheme.radiusMedium);

    return Dismissible(
      key: ValueKey(message.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
        decoration:
            BoxDecoration(color: appColors.danger, borderRadius: radius),
        child: Icon(Icons.delete_outline_rounded, color: appColors.onDanger),
      ),
      child: Material(
        color: unread ? colors.surfaceContainer : colors.surfaceContainerLow,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: unread
                    ? colors.primary.withValues(alpha: AppTheme.opacityGlow)
                    : colors.outline.withValues(alpha: AppTheme.opacityGlass),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SenderAvatar(name: message.displayName),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleSmall?.copyWith(
                                fontWeight:
                                    unread ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (message.hasAttachments)
                            Icon(Icons.attach_file_rounded,
                                size: AppTheme.iconSm,
                                color: appColors.subtleText),
                          const SizedBox(width: AppTheme.spacingXs),
                          Text(_time(message.createdAt),
                              style: text.labelSmall
                                  ?.copyWith(color: appColors.subtleText)),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXs),
                      Text(
                        message.displaySubject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium?.copyWith(
                          fontWeight:
                              unread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      if (message.intro.isNotEmpty) ...[
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          message.intro,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall
                              ?.copyWith(color: appColors.subtleText),
                        ),
                      ],
                    ],
                  ),
                ),
                if (unread) ...[
                  const SizedBox(width: AppTheme.spacingSm),
                  Container(
                    width: AppTheme.pulseDot,
                    height: AppTheme.pulseDot,
                    margin: const EdgeInsets.only(top: AppTheme.spacingSm),
                    decoration: BoxDecoration(
                        color: colors.primary, shape: BoxShape.circle),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
