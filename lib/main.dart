import 'package:assignment2/screen/home_screen.dart';
import 'package:assignment2/screen/splash_screen.dart';
import 'package:assignment2/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.generateRoute,
      home: SplashScreen(),
    );
  }
}

