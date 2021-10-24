import 'package:flutter/material.dart';
import 'package:psychonauts_app/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Psychonauts App',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
} 