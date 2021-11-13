class Todo {
  String id;
  String title;
  bool isCompleted;

  Todo(this.id, this.title, this.isCompleted);
  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      json['id'].toString(),
      json['title'] as String,
      json['isCompleted'] as bool,
    );
  }

  @override
  String toString() =>
      'Todo(id: $id, title: $title, isCompleted: $isCompleted)';
}
