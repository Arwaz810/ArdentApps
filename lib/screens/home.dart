import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: Row(
          children: [
            Image.network(
              'https://wallpapercave.com/wp/wp2880157.jpg',
              width: 200,
              height: 250,
            ),
          ],
        ));
  }
}
