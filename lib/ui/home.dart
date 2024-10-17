import 'package:TaskMaster/ui/tasks/create_task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:TaskMaster/service/task_service.dart';
import 'package:TaskMaster/repository/task_repository.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF33138C),
      body: BlocProvider(
        create: (context) => TaskRepository(TaskService()),
        child: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late TaskRepository taskRepository;
  List<Map<String, String>> tasks = [];
  List<Map<String, String>> filteredTasks = [];
  bool hasTasksForSelectedDate = false;
  DateTime selectedDate = DateTime.now();
  String currentDate = DateFormat('d MMMM, yyyy').format(DateTime.now());

  // Function to get the names of the next 7 days including today
  List<DateTime> getNext7Days() {
    DateTime today = DateTime.now();
    List<DateTime> days = [];
    for (int i = 0; i < 7; i++) {
      days.add(today.add(Duration(days: i)));
    }
    return days;
  }

  bool checkForTasks(DateTime date) {
    return tasks.any((task) => DateTime.parse(task['date'] ?? '') == date);
  }

  List<Map<String, String>> filterTasksByDate(DateTime date) {
    return tasks.where((task) {
      String dateString = task['date']!;
      String datePart = dateString.split(' ')[0];
      List<String> dateComponents = datePart.split('-');
      String taskYear = dateComponents[0];
      String taskMonth = dateComponents[1];
      String taskDay = dateComponents[2];

      return int.parse(taskYear) == selectedDate.year &&
          int.parse(taskMonth) == selectedDate.month &&
          int.parse(taskDay) == selectedDate.day;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    taskRepository = TaskRepository(TaskService());
    taskRepository.add(FetchTasks());

    if (selectedDate.day == DateTime.now().day) {
      setState(() {
        hasTasksForSelectedDate = checkForTasks(selectedDate);
        filteredTasks = filterTasksByDate(selectedDate);
      });

      print('is it true? $hasTasksForSelectedDate');
    }

  }

  @override
  void dispose() {
    taskRepository.close();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDate,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDate = newDate;
              currentDate = DateFormat('d MMMM, yyyy').format(selectedDate);
              filteredTasks = filterTasksByDate(selectedDate);
              hasTasksForSelectedDate = checkForTasks(selectedDate);
            });
          },
        ),
      ),
    );
  }

  List<Map<String, String>> getTasksForSelectedDate(List<Map<String, String>> tasks) {
    print('Selected Date: $selectedDate');
    print('Tasks: ${tasks.map((task) => task['date']).toList()}');
    return tasks.where((task) {
      // Ensure 'date' field exists and is formatted correctly
      String? dateString = task['date'];
      if (dateString != null) {
        String dateString = task['date']!;
        String datePart = dateString.split(' ')[0];
        List<String> dateComponents = datePart.split('-');
        String taskYear = dateComponents[0];
        String taskMonth = dateComponents[1];
        String taskDay = dateComponents[2];
        print(dateString);
        return int.parse(taskYear) == selectedDate.year &&
            int.parse(taskMonth) == selectedDate.month &&
            int.parse(taskDay) == selectedDate.day;
      }
      return false; // Return false if dateString is null or improperly formatted
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<DateTime> days = getNext7Days();
    final taskRepository = BlocProvider.of<TaskRepository>(context);
    taskRepository.add(FetchTasks());

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF012087),
              Color(0xFF00CCFF),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: size.height * 0.05,
              left: 20,
              right: 20,
              child: Row(
                children: <Widget>[
                  const Text(
                    "TaskMaster",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => CreateTask()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.blueAccent,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.15,
              left: 20,
              child: Container(
                width: size.width,
                padding: EdgeInsets.fromLTRB(0, 0, 40, 0),
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    text: currentDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1.0,
                      decoration: TextDecoration.none,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _showDatePicker(context);
                      },
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.20,
              left: 12,
              right: 20,
              child: SizedBox(
                height: size.height * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var day in days)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedDate = day;
                                currentDate = DateFormat('d MMMM, yyyy').format(selectedDate);
                              });
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: day.day == DateTime.now().day ? Colors.white : Colors.transparent,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      DateFormat('d').format(day),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: day.day == DateTime.now().day ? Colors.black : Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      DateFormat('MMM').format(day),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: day.day == DateTime.now().day ? Colors.black : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.30,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: size.height,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 60),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: BlocBuilder<TaskRepository, TaskState>(
                  builder: (context, state) {
                    if (state is TaskInitial) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is TaskLoaded) {
                      final tasksForSelectedDate = getTasksForSelectedDate(state.tasks);
                      final tasksArray = state.tasks;
                      if (tasksArray.isNotEmpty) {
                        return buildTaskList(state.tasks, size);
                      } else {
                        return TasksEmpty();
                      }
                    } else {
                      return TasksNotLoaded();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/empty-list.png', height: 220.0)],
          ),
          Text(
            'Oops! Something went wrong!',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class TasksEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/empty-list.png', height: 220.0)],
          ),
          Text(
            'You have no tasks for this date.',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildTaskList(List<Map<String, String>> tasks, Size size) {
  return SingleChildScrollView(
    child: Column(
      children: tasks.map((task) => buildTaskItem(task, size)).toList(),
    ),
  );
}

Widget buildTaskItem(Map<String, String> task, Size size) {
  return Stack(
    children: <Widget>[
      Container(
        width: size.width,
        height: size.height * 0.15,
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              task['label'] ?? '',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              task['description'] ?? '',
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 0,
        right: 20,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              task['time'] ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.black,
                size: 20.0,
              ),
            ),
            Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.black,
                size: 20.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

