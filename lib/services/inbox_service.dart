import '../models/mail_account.dart';
import '../models/mail_message.dart';
import '../repositories/mail_repository.dart';

class InboxService {
  InboxService({required MailRepository repository}) : _repo = repository;

  final MailRepository _repo;

  /// Restores the saved mailbox; returns null when none exists or the server rejects its key.
  Future<MailAccount?> restoreAccount() async {
    final saved = await _repo.loadSavedAccount();
    if (saved == null) return null;
    try {
      await _repo.fetchMessages(saved.secretKey);
      return saved;
    } on MailApiException {
      await _repo.clearSavedAccount();
      return null;
    }
  }

  Future<MailAccount> createAccount() async {
    final account = await _repo.requestAccount();
    await _repo.saveAccount(account);
    return account;
  }

  Future<List<MailMessage>> fetchMessages(MailAccount account) async {
    final list = await _repo.fetchMessages(account.secretKey);
    //list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
