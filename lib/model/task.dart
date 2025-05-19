import 'package:task_manager_project/model/user.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final User assignedTo;
  final User createdBy;
  final DateTime dueDate;
  late final String status;
  final List<Comment> comments;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.createdBy,
    required this.dueDate,
    required this.status,
    required this.comments,
  });

  factory Task.fromJson(Map<dynamic, dynamic> json) => Task(
        id: json['id'] ?? '',
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? 'No Description',
        assignedTo:
            User.fromJson(Map<String, dynamic>.from(json['assignedTo'] ?? {})),
        createdBy:
            User.fromJson(Map<String, dynamic>.from(json['createdBy'] ?? {})),
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'])
            : DateTime.now(),
        status: json['status'] ?? 'Assigned',
        comments: json['comments'] != null
            ? List<Comment>.from((json['comments'] as List)
                .map((x) => Comment.fromJson(Map<String, dynamic>.from(x))))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'assignedTo': assignedTo.toJson(),
        'createdBy': createdBy.toJson(),
        'dueDate': dueDate.toIso8601String(),
        'status': status,
        'comments': comments.map((x) => x.toJson()).toList(),
      };
}

class Comment {
  final String id;
  final User author;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        author: User.fromJson(json['author'] ?? {}),
        text: json['text'],
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author.toJson(),
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };
}
