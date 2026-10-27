import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/inbox_provider.dart';
import '../theme/responsive_layout.dart';
import '../theme/theme.dart';
import '../widgets/common/state_view.dart';
import '../widgets/inbox/address_card.dart';
import '../widgets/inbox/inbox_header.dart';
import '../widgets/inbox/message_tile.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  Future<void> _copy(BuildContext context, String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address copied to clipboard')),
    );
  }

  Future<void> _confirmNew(BuildContext context, InboxProvider inbox) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Get a new address?'),
        content: const Text(
            'Your current address and its messages will no longer be shown.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Generate')),
        ],
      ),
    );
    if (ok == true) inbox.newAddress();
  }

  @override
  Widget build(BuildContext context) {
    final inbox = context.watch<InboxProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final padding = ResponsiveLayout.getPadding(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    final Widget body;
    if (inbox.account == null && inbox.setupError != null) {
      body = SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: StateView(
            icon: Icons.cloud_off_rounded,
            title: 'Couldn\'t create your inbox',
            message: inbox.setupError!,
            actionLabel: 'Try again',
            onAction: inbox.init,
          ),
        ),
      );
    } else if (inbox.messages.isEmpty) {
      body = SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: StateView(
            imageAsset: 'assets/images/empty_inbox.png',
            title: 'Waiting for mail',
            message:
                'Use your address on any sign-up form. New emails appear here automatically.',
          ),
        ),
      );
    } else {
      body = SliverList.separated(
        itemCount: inbox.messages.length,
        // Changed the second argument to __ to prevent the duplicate name error
        separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
        itemBuilder: (context, i) {
          final m = inbox.messages[i];
          final tile = ResponsiveLayout.constrain(MessageTile(
            message: m,
            onTap: () => context.push('/message/${m.id}'),
            onDelete: () => inbox.deleteMessage(m.id),
          ));
          if (reduceMotion) return tile;
          return tile
              .animate()
              .fadeIn(
                  delay: Duration(milliseconds: 40 * i.clamp(0, 10)),
                  duration: 300.ms)
              .slideY(begin: 0.08, end: 0);
        },
      );
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: theme.appBarTheme.systemOverlayStyle!,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.surfaceContainerLow, colors.surface],
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: inbox.refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: padding,
                    sliver: SliverToBoxAdapter(
                      child: ResponsiveLayout.constrain(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.alternate_email_rounded,
                                    color: colors.primary),
                                const SizedBox(width: AppTheme.spacingSm),
                                Text('TempInbox',
                                    style: theme.textTheme.titleLarge),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingLg),
                            AddressCard(
                              address: inbox.account?.address,
                              isCreating:
                                  inbox.isCreating || inbox.account == null,
                              onCopy: () =>
                                  _copy(context, inbox.account!.address),
                              onNewAddress: () => _confirmNew(context, inbox),
                            ),
                            const SizedBox(height: AppTheme.spacingXl),
                            InboxHeader(
                              total: inbox.messages.length,
                              unread: inbox.unreadCount,
                              isRefreshing: inbox.isRefreshing,
                              errorText: inbox.inboxError,
                              onRefresh: inbox.refresh,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: padding.copyWith(top: 0),
                    sliver: body,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
