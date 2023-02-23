import 'package:flutter/material.dart';
import 'package:weather_app/core/widgets/main_wrapper.dart';
import 'package:weather_app/locator.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainWrapper(),
    );
  }
}
