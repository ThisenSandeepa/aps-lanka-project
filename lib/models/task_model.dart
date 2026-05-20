class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.completed,
    this.isLocal = false,
  });

  final int id;
  final String title;
  final bool completed;
  final bool isLocal;

  factory TaskModel.fromJson(Map<String, dynamic> json, {bool isLocal = false}) {
    return TaskModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '').toString(),
      completed: json['completed'] == true,
      isLocal: isLocal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'isLocal': isLocal,
    };
  }

  TaskModel copyWith({
    int? id,
    String? title,
    bool? completed,
    bool? isLocal,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}
