import 'package:flutter/material.dart';
import 'package:mynotes/screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes App',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.grey[100]),
      home: HomePage(title: 'My Notes'),
    );
  }
}
