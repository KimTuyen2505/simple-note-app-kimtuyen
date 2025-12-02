class Note {
  final int? id;
  final String title;
  final String content;
  final String tag;
  final bool pinned;
  final bool locked;
  final String? password;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.tag,
    required this.pinned,
    required this.locked,
    this.password,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'tag': tag,
        'pinned': pinned ? 1 : 0,
        'locked': locked ? 1 : 0,
        'password': password,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromMap(Map<String, dynamic> m) => Note(
        id: m['id'] as int?,
        title: m['title'] ?? '',
        content: m['content'] ?? '',
        tag: m['tag'] ?? 'Work',
        pinned: (m['pinned'] ?? 0) == 1,
        locked: (m['locked'] ?? 0) == 1,
        password: m['password'] as String?,
        updatedAt: DateTime.parse(m['updatedAt']),
      );
}
