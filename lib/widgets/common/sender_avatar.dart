import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class SenderAvatar extends StatelessWidget {
  final String name;

  const SenderAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return Container(
      width: AppTheme.avatarMd,
      height: AppTheme.avatarMd,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: colors.primaryContainer, shape: BoxShape.circle),
      child: Text(
        initial,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: colors.onPrimaryContainer),
      ),
    );
  }
}
