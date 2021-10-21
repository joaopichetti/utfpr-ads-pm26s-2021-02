import 'package:flutter/material.dart';
import 'package:usando_gps/pages/home_page.dart';

void main() {
  runApp(const UsandoGpsApp());
}

class UsandoGpsApp extends StatelessWidget {
  const UsandoGpsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usando GPS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
