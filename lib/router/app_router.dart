import 'package:go_router/go_router.dart';

import '../screens/inbox_screen.dart';
import '../screens/message_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const InboxScreen()),
      GoRoute(
        path: '/message/:id',
        builder: (context, state) =>
            MessageScreen(messageId: state.pathParameters['id']!),
      ),
    ],
  );
}
