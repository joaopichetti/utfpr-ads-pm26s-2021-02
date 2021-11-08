import 'package:cadastro_pontos_turisticos/pages/lista_pontos_turisticos_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pontos Turísticos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListaPontosTuristicosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
