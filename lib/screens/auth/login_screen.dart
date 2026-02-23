import 'package:chat_application/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            height: mq.height * .1,
            left: mq.width * .25,
            child: Image.asset('assets/images/login.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width * .9,
            height: mq.height * 0.07,
            left: mq.width * .05,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              icon: Image.asset('assets/images/google.png'),
              label: Text('Login with google'),
            ),
          ),
        ],
      ),
    );
  }
}
