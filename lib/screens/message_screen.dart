import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/inbox_provider.dart';
import '../theme/responsive_layout.dart';
import '../theme/theme.dart';
import '../widgets/common/sender_avatar.dart';
import '../widgets/common/state_view.dart';

class MessageScreen extends StatefulWidget {
  final String messageId;

  const MessageScreen({super.key, required this.messageId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<InboxProvider>().openMessage(widget.messageId);
    });
  }

  Future<void> _delete() async {
    final ok =
        await context.read<InboxProvider>().deleteMessage(widget.messageId);
    if (ok && mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final inbox = context.watch<InboxProvider>();
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final msg = inbox.openedMessage?.id == widget.messageId
        ? inbox.openedMessage
        : null;

    final Widget content;
    if (inbox.openError != null) {
      content = Center(
        child: StateView(
          icon: Icons.mark_email_unread_outlined,
          title: 'Couldn\'t open this email',
          message: inbox.openError!,
          actionLabel: 'Retry',
          onAction: () => inbox.openMessage(widget.messageId),
        ),
      );
    } else if (msg == null) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      final body = msg.bodyText;
      content = SingleChildScrollView(
        padding: ResponsiveLayout.getPadding(context),
        child: ResponsiveLayout.constrain(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.displaySubject, style: text.headlineSmall),
              const SizedBox(height: AppTheme.spacingLg),
              Row(
                children: [
                  SenderAvatar(name: msg.displayName),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.displayName,
                            style: text.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(msg.fromAddress,
                            style: text.bodySmall
                                ?.copyWith(color: appColors.subtleText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Text(DateFormat.MMMd().add_jm().format(msg.createdAt),
                      style: text.labelSmall
                          ?.copyWith(color: appColors.subtleText)),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: SelectableText(
                    body.isEmpty
                        ? 'TemporaryMail only shares the sender, subject and time of each '
                            'email, so the message content cannot be shown here.'
                        : body,
                    style: text.bodyLarge?.copyWith(height: 1.55),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        actions: [
          IconButton(
            tooltip: 'Remove email from this device',
            onPressed: msg == null ? null : _delete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(child: content),
    );
  }
}
