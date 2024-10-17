import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:TaskMaster/model/task.dart';

class TaskService {

  Future<List<Map<String, String>>> fetchTasks() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? tasks = sharedPreferences.getStringList('tasks');
    return tasks != null
        ? tasks.map((task) => Map<String, String>.from(json.decode(task))).toList()
        : [];
  }

  Future<void> createTask(String date, String time, String label, String description) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? existingTasks = sharedPreferences.getStringList('tasks') ?? [];

    var random = Random();
    var randomNumber = random.nextInt(1000);

    Map<String, String> newTask = {
      'id': randomNumber.toString(),
      'date': date,
      'time': time,
      'label': label,
      'description': description,
    };
    String newTaskJson = jsonEncode(newTask);
  print(newTaskJson);
    existingTasks.add(newTaskJson);
    await sharedPreferences.setStringList('tasks', existingTasks);
  }
}