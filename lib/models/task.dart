class Task {
  final int id;
  final String title;
  final String description;
  final bool isComplete;

  Task({required this.id, required this.title, this.description = '', this.isComplete = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isComplete: json['isComplete'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isComplete': isComplete ? 1 : 0,
  };
}

