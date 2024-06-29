class Task {
  String task;
  DateTime time;

  // Constructor with required parameters
  Task({required this.task, required this.time});

  // Factory constructor to create a Task from a string
  factory Task.fromString(String task) {
    return Task(
      task: task,
      time: DateTime.now(),
    );
  }

  // Factory constructor to create a Task from a map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      task: map['task'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  // Method to convert a Task to a map
  Map<String, dynamic> getMap() {
    return {
      'task': this.task,
      'time': this.time.millisecondsSinceEpoch,
    };
  }
}
