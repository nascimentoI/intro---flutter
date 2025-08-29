import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/counter_screen_page.dart';
import 'package:flutter_application_1/pages/home_screen_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      )  
    );
  } 
}