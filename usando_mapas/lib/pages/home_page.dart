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
  final _controller = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Endereço ou Ponto de Referência',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.map),
                  tooltip: 'Abrir no mapa',
                  onPressed: _abrirEnderecoNoMapa,
                ),
              ),
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

  void _abrirEnderecoNoMapa() {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    MapsLauncher.launchQuery(_controller.text);
  }
}
