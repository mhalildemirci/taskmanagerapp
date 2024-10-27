class Task {
  String name;
  String description;
  DateTime dateTime;
  bool isCompleted;

  Task({
    required this.name,
    this.description = '',
    required this.dateTime,
    this.isCompleted = false,
  });
}
