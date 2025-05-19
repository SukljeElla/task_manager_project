class Ticket {
  final String id;
  final String text;
  final DateTime createdAt;
  final String authorId;
  final String authorName;

  Ticket({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      authorId: json['authorId'],
      authorName: json['authorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'authorId': authorId,
      'authorName': authorName,
    };
  }
}
