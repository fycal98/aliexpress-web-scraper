import 'package:flutter/material.dart';
import 'package:web_scraper/web_scraper.dart';
import 'view/Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
