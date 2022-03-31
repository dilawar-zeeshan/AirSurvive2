import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:showcaseview/showcaseview.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShowCaseWidget(
        builder: Builder(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }
}




