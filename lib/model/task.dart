class Task {
  String id;
  String date;
  String time;
  String label;
  String description;

  Task({required this.id, required this.date, required this.time, required this.label, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'label': label,
      'description': description,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      label: json['label'],
      description: json['description'],
    );
  }
}