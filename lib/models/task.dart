class Task {
  String? documentId;
  String taskName;
  String startTime;
  String endTime;
  String? description;
  DateTime date;
  String userId;


  Task({
    this.documentId,
    required this.taskName,
    required this.startTime,
    required this.endTime,
    this.description,
    required this.date,
    required this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json, docId) {
    return Task(
      documentId: docId,
      taskName: json['task_name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      description: json['description'],
      date: json['date'].toDate(),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_name': taskName,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'date': date,
      'user_id': userId,
    };
  }
}
