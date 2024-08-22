import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:TaskMaster/welcome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Function to get the names of the next 7 days including today
  List<DateTime> getNext7Days() {
    DateTime today = DateTime.now();
    List<DateTime> days = [];
    for (int i = 0; i < 7; i++) {
      days.add(today.add(Duration(days: i)));
    }
    return days;
  }

  bool hasTasksForSelectedDate = false;
  DateTime selectedDate = DateTime.now();

  bool checkForTasks(DateTime date) {
    return date.day == DateTime.now().day;
  }

  @override
  void initState() {
    super.initState();
    // Automatically show items if the current date is selected
    if (selectedDate.day == DateTime.now().day) {
      setState(() {
        hasTasksForSelectedDate = checkForTasks(selectedDate);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<DateTime> days = getNext7Days();
    String currentDate = DateFormat('E,d MMMM').format(DateTime.now());

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xFF012087),
                const Color(0xFF00CCFF),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp
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
                          MaterialPageRoute(builder: (context) => Welcome()),
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
                        weight: 600,
                        size: 30.0,
                      )
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.15,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: size.width/2,
                    child: Text(
                      days[0].day == DateTime.now().day ? "Today" : DateFormat('EEEE').format(DateTime.now().day as DateTime),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width/2,
                    padding: EdgeInsets.fromLTRB(00, 00, 40, 00),
                    child: Text(
                      currentDate,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.0,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.20,
              left: 12,
              right: 20,
              child: SizedBox(
                height: size.height * 0.4, // Limit the height for scrolling
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
                                hasTasksForSelectedDate = checkForTasks(day);
                                print(hasTasksForSelectedDate);
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
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 00),
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 60),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: (hasTasksForSelectedDate) ?
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height*0.15,
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'Complete Project Report',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Finalize and submit the project report for the client review.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
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
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: const Offset(0, 5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '10.00 AM',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0
                                      ),
                                    ),
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
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height*0.15,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'Schedule Team Meeting',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Arrange a meeting with the development team to discuss the upcoming sprint.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
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
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: const Offset(0, -14.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '10.45 AM',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0
                                      ),
                                    ),
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
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height*0.15,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'Update Software Documentation',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Review and update the software documentation to reflect the latest changes in the codebase.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
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
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: const Offset(0, -14.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '11.15 AM',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0
                                      ),
                                    ),
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
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height*0.15,
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text(
                                  'Review Marketing Strategy',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'DM Sans',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Assess the current marketing strategy for the new product launch.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
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
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: const Offset(0, -14.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '12.00 PM',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0
                                      ),
                                    ),
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
                      ),
                    ],
                  ),
                )
                :
                Container(
                  child:  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      iconSize: 100,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.black26,
                      ),
                      onPressed: () {
                        // Action to add new task
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}