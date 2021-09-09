import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlutterLogo(
              size: 100,
            ),
            Text(
              'Welcome to the Internship App',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 30.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Home(),
                ),
              ),
              child: Text('Move Next'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
