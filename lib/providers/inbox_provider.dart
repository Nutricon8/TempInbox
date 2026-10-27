import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/mail_account.dart';
import '../models/mail_message.dart';
import '../services/inbox_service.dart';

class InboxProvider extends ChangeNotifier {
  InboxProvider({required InboxService service}) : _service = service;

  final InboxService _service;
  Timer? _poll;

  MailAccount? account;
  List<MailMessage> messages = [];
  bool isCreating = false;
  bool isRefreshing = false;
  String? setupError;
  String? inboxError;

  MailMessage? openedMessage;
  bool isOpening = false;
  String? openError;

  // The service has no read or delete endpoints, so both are tracked on this device.
  final Set<String> _seenIds = {};
  final Set<String> _removedIds = {};

  int get unreadCount => messages.where((m) => !m.seen).length;

  String _describe(Object e) =>
      e is Exception && e.toString().startsWith('Mail')
          ? e.toString()
          : 'Could not reach the mail server: $e';

  Future<void> init() async {
    isCreating = true;
    setupError = null;
    notifyListeners();
    try {
      account =
          await _service.restoreAccount() ?? await _service.createAccount();
      isCreating = false;
      notifyListeners();
      await refresh();
      _startPolling();
    } catch (e) {
      setupError = _describe(e);
      isCreating = false;
      notifyListeners();
    }
  }

  Future<void> newAddress() async {
    _poll?.cancel();
    final previous = account;
    isCreating = true;
    inboxError = null;
    notifyListeners();
    try {
      account = await _service.createAccount();
      messages = [];
      _seenIds.clear();
      _removedIds.clear();
      isCreating = false;
      notifyListeners();
      _startPolling();
    } catch (e) {
      account = previous;
      inboxError = _describe(e);
      isCreating = false;
      notifyListeners();
      if (previous != null) _startPolling();
    }
  }

  void _startPolling() {
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 10), (_) => refresh());
  }

  Future<void> refresh() async {
    final acc = account;
    if (acc == null || isRefreshing) return;
    isRefreshing = true;
    notifyListeners();
    try {
      final fetched = await _service.fetchMessages(acc);
      messages = [
        for (final m in fetched)
          if (!_removedIds.contains(m.id))
            _seenIds.contains(m.id) ? m.copyWith(seen: true) : m,
      ];
      inboxError = null;
    } catch (e) {
      inboxError = _describe(e);
    } finally {
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> openMessage(String id) async {
    final acc = account;
    openedMessage = null;
    openError = null;
    if (acc == null) {
      openError =
          'No active inbox yet. Go back and wait for your address to be created.';
      notifyListeners();
      return;
    }
    isOpening = true;
    notifyListeners();
    try {
      if (!messages.any((m) => m.id == id)) await refresh();
      final found = messages.where((m) => m.id == id).firstOrNull;
      if (found == null) {
        openError = 'This email is no longer in the inbox.';
      } else {
        _seenIds.add(id);
        openedMessage = found.copyWith(seen: true);
        messages = [for (final m in messages) m.id == id ? openedMessage! : m];
      }
    } finally {
      isOpening = false;
      notifyListeners();
    }
  }

  /// Removes the email from this device's inbox view; the service offers no delete endpoint.
  Future<bool> deleteMessage(String id) async {
    _removedIds.add(id);
    messages = messages.where((m) => m.id != id).toList();
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}
