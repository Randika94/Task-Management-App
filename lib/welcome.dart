import 'package:flutter/material.dart';
import 'package:task_management_app/ui/home.dart';
import 'package:task_management_app/ui/register.dart';

void main() {
  runApp(const Welcome());
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      home: const Body(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'DM Sans',
        primaryColor: const Color(0xFF480BBB),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFAAAAAA)),
      ),
    );
  }

  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new ExactAssetImage('assets/welcome-screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
          Image.asset('assets/welcome.png', width: 250, alignment: Alignment.bottomCenter),
          SizedBox(height: 30),
          Center(
            child: Text(
              "TASKMASTER",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(height: 6.0),
          Center(
            child: Text(
              "Organize Your Day, Achieve Your Goals",
              style: TextStyle(
                color:  Color(0xFF050505),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                // letterSpacing: 1.0,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 60.0,
            width: 350.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blueAccent,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                        (route) => false,
                  );
                },
                child: Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            height: 60.0,
            width: 350.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blueAccent,
            ),
            child: Material(
              color: Colors.transparent, // Use transparent to allow color from Container
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                        (route) => false,
                  );
                },
                child: Center(
                  child: Text(
                    'I have an Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
