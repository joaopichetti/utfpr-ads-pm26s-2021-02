import 'package:cadastro_contatos/pages/lista_contatos_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } catch (e, s) {
    debugPrint('Error: $e');
    debugPrint('Stack: $s');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contatos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListaContatosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
