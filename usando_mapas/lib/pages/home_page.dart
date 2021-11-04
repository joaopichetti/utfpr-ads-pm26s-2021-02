import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _localizacaoAtual;

  String get _textoLocalizacao => _localizacaoAtual == null
      ? ''
      : 'Latitude: ${_localizacaoAtual!.latitude} | Longitude: ${_localizacaoAtual!.longitude}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testando Mapas'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              child: const Text('Obter localização atual'),
              onPressed: _obterLocalizacaoAtual,
            ),
          ),
          if (_localizacaoAtual != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(_textoLocalizacao),
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.map),
                    onPressed: _abrirCoordenadasNoMapa,
                  ),
                ],
              ),
            ),
        ],
      );

  void _obterLocalizacaoAtual() async {
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  void _abrirCoordenadasNoMapa() {
    if (_localizacaoAtual == null) {
      return;
    }
    MapsLauncher.launchCoordinates(
      _localizacaoAtual!.latitude,
      _localizacaoAtual!.longitude,
    );
  }
}
