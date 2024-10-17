import 'package:TaskMaster/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TaskMaster/repository/task_repository.dart';
import 'package:TaskMaster/service/task_service.dart';

class CreateTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF33138C),
      body: BlocProvider(
        create: (context) => TaskRepository(TaskService()),
        child: CreateTaskBody(),
      ),
    );
  }
}

class CreateTaskBody extends StatefulWidget {
  const CreateTaskBody({super.key});

  @override
  _CreateTaskBodyState createState() => _CreateTaskBodyState();
}

class _CreateTaskBodyState extends State<CreateTaskBody> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDateTime = DateTime.now();
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _label = TextEditingController();
  TextEditingController _description = TextEditingController();


  @override
  void initState() {
    super.initState();
    _date.text = formatDate(selectedDateTime);
    _time.text = formatTime(selectedDateTime);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date); // Format date as MM-DD-YYYY
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: selectedDateTime,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDateTime = newDate;
              _date.text = formatDate(selectedDateTime);
            });
          },
        ),
      ),
    );
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time); // 'a' adds AM/PM
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false, // 12-hour format with AM/PM
          initialDateTime: selectedDateTime,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              selectedDateTime = newTime;
              _time.text = formatTime(selectedDateTime);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Create Task',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: FloatingActionButton(
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            weight: 600,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _date,
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.calendar_today),
                          onPressed: () => _showDatePicker(context), // Show Date Picker
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // TextFormField for Time Picker
                    TextFormField(
                      controller: _time,
                      readOnly: true, // Prevent manual input
                      decoration: InputDecoration(
                        labelText: 'Select Time',
                        suffixIcon: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.access_time),
                          onPressed: () => _showTimePicker(context), // Show Time Picker
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _label,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        hintText: 'Enter your task heading',
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your task heading';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter your task description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your task description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height/2,
                alignment: AlignmentDirectional.bottomEnd,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                              (route) => false,
                        );
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Save Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final taskEvent = CreateNewTask(
                            _date.text,
                            _time.text,
                            _label.text,
                            _description.text,
                          );

                          BlocProvider.of<TaskRepository>(context).add(taskEvent);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                              'Registered Successfully!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Registered Successfully!',
                              onPressed: () {},
                            ),
                          ));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                                (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(
                              'Please fill required fields!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 1),
                            action: SnackBarAction(
                              label: 'Not Processing Data',
                              onPressed: () {},
                            ),
                          ));
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
