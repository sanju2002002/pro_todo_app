class TodoItem {
  final String id;
  final String text;
  final DateTime createdAt;
  bool isCompleted;
  DateTime? completedAt;

  TodoItem({
    required this.text,
    required this.createdAt,
    this.isCompleted = false,
    this.completedAt,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  TodoItem copyWith({String? text, bool? isCompleted, DateTime? completedAt}) {
    return TodoItem(
      text: text ?? this.text,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
