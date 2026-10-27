import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/inbox_provider.dart';
import 'repositories/mail_repository.dart';
import 'router/app_router.dart';
import 'services/inbox_service.dart';
import 'theme/theme.dart';

void main() => runApp(const TempInboxApp());

class TempInboxApp extends StatelessWidget {
  const TempInboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => MailRepository()),
        Provider(
            create: (ctx) =>
                InboxService(repository: ctx.read<MailRepository>())),
        ChangeNotifierProvider(
          create: (ctx) =>
              InboxProvider(service: ctx.read<InboxService>())..init(),
        ),
      ],
      child: MaterialApp.router(
        title: 'TempInbox',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
