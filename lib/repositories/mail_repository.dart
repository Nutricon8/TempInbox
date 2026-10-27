import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mail_account.dart';
import '../models/mail_message.dart';

class MailApiException implements Exception {
  final String message;
  final int? statusCode;

  const MailApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Data access for the public TemporaryMail API plus on-device storage of the current mailbox.
class MailRepository {
  static const _base = 'https://tempmail-production-6fcd.up.railway.app/api/';
  static const _kAddress = 'tempinbox.tm.address';
  static const _kSecretKey = 'tempinbox.tm.secretKey';

  final http.Client _client = http.Client();

  Future<dynamic> _get(Map<String, String> query) async {
    final res =
        await _client.get(Uri.parse(_base).replace(queryParameters: query));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      if (res.statusCode == 429) {
        throw MailApiException(
          'Too many requests to the mail server. Wait a moment and try again.',
          statusCode: 429,
        );
      }
      throw MailApiException('Mail server error (${res.statusCode}).',
          statusCode: res.statusCode);
    }
    try {
      return jsonDecode(res.body);
    } on FormatException {
      throw const MailApiException('Mail server sent an unexpected response.');
    }
  }

  Future<MailAccount> requestAccount() async {
    final data = await _get(
        {'action': 'requestEmailAccess', 'key': '', 'value': 'random'});
    if (data is Map &&
        data['address'] is String &&
        data['secretKey'] is String) {
      return MailAccount(
        address: data['address'] as String,
        secretKey: data['secretKey'] as String,
      );
    }
    throw const MailApiException('Mail server did not return a new address.');
  }

  /// The inbox is `[]` when empty, otherwise a map of message id to message summary.
  Future<List<MailMessage>> fetchMessages(String secretKey) async {
    final data = await _get({'action': 'checkInbox', 'value': secretKey});
    if (data is List) return const [];
    if (data is Map) {
      final items = data.values.whereType<Map>().toList();
      if (items.length != data.length) {
        final detail = data.values.whereType<String>().firstOrNull;
        throw MailApiException(
          detail == null
              ? 'Mail server sent an unexpected inbox.'
              : 'Mail server error: $detail',
        );
      }
      return items
          .map((m) => MailMessage.fromJson(m.cast<String, dynamic>()))
          .toList();
    }
    throw const MailApiException('Mail server sent an unexpected inbox.');
  }

  Future<MailAccount?> loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString(_kAddress);
    final secretKey = prefs.getString(_kSecretKey);
    if (address == null || secretKey == null) return null;
    return MailAccount(address: address, secretKey: secretKey);
  }

  Future<void> saveAccount(MailAccount account) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAddress, account.address);
    await prefs.setString(_kSecretKey, account.secretKey);
  }

  Future<void> clearSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAddress);
    await prefs.remove(_kSecretKey);
  }
}
