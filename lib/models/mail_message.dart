class MailMessage {
  final String id;
  final String fromName;
  final String fromAddress;
  final String subject;
  final String intro;
  final bool seen;
  final bool hasAttachments;
  final DateTime createdAt;
  final String? text;
  final String? html;

  const MailMessage({
    required this.id,
    required this.fromName,
    required this.fromAddress,
    required this.subject,
    required this.intro,
    required this.seen,
    required this.hasAttachments,
    required this.createdAt,
    this.text,
    this.html,
  });

  factory MailMessage.fromJson(Map<String, dynamic> json) {
    final seconds = json['date'];
    final attachments = json['attachments'];
    return MailMessage(
      id: json['id'] as String,
      fromName: (json['name'] as String?) ?? '',
      fromAddress: (json['from'] as String?) ?? '',
      subject: (json['subject'] as String?) ?? '',
      intro: '',
      seen: false,
      hasAttachments: attachments is List && attachments.isNotEmpty,
      createdAt: seconds is num
          ? DateTime.fromMillisecondsSinceEpoch(seconds.toInt() * 1000)
          : DateTime.now(),
    );
  }

  MailMessage copyWith({bool? seen}) => MailMessage(
        id: id,
        fromName: fromName,
        fromAddress: fromAddress,
        subject: subject,
        intro: intro,
        seen: seen ?? this.seen,
        hasAttachments: hasAttachments,
        createdAt: createdAt,
        text: text,
        html: html,
      );

  String get displayName => fromName.trim().isNotEmpty ? fromName : fromAddress;

  String get displaySubject =>
      subject.trim().isNotEmpty ? subject : '(no subject)';

  /// Plain-text body: the text part when present, otherwise the HTML with tags removed.
  String get bodyText {
    final plain = text?.trim() ?? '';
    if (plain.isNotEmpty) return plain;
    final raw = html ?? '';
    return raw
        .replaceAll(
            RegExp(r'<(style|script)[\s\S]*?</\1>', caseSensitive: false), '')
        .replaceAll(
            RegExp(r'<br\s*/?>|</p>|</div>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n\s*\n+'), '\n\n')
        .trim();
  }
}
