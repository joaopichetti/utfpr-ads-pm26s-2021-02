import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _linhas = <String>[];
  StreamSubscription<Position>? _subscription;
  Position? _ultimaPosicaoObtida;
  double _distanciaTotalPercorrida = 0;

  bool get _monitorandoLocalizacao => _subscription != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usando GPS'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Obter última localização conhecida'),
              onPressed: _obterUltimaLocalizacao,
            ),
            ElevatedButton(
              child: const Text('Obter localização atual'),
              onPressed: _obterLocalizacaoAtual,
            ),
            ElevatedButton(
              child: Text(_monitorandoLocalizacao
                  ? 'Parar monitoramento'
                  : 'Monitorar localização do usuário'),
              onPressed: _monitorandoLocalizacao
                  ? _pararMonitoramento
                  : _monitorarLocalizacao,
            ),
            ElevatedButton(
              child: const Text('Limpar log'),
              onPressed: _limparLog,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _linhas.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(_linhas[index]),
                ),
              ),
            ),
          ],
        ),
      );

  void _obterUltimaLocalizacao() async {
    bool permissoesPermitidas = await _permissoesPermitidas();
    if (!permissoesPermitidas) {
      return;
    }
    Position? position = await Geolocator.getLastKnownPosition();
    setState(() {
      if (position == null) {
        _linhas.add('Nenhuma localização registrada');
      } else {
        _linhas.add(
            'Latitude: ${position.latitude} | Longitude: ${position.longitude}');
      }
    });
  }

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if (!servicoHabilitado) {
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if (!permissoesPermitidas) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _linhas.add(
          'Latitude: ${position.latitude} | Longitude: ${position.longitude}');
    });
  }

  void _monitorarLocalizacao() {
    _subscription = Geolocator.getPositionStream(
      distanceFilter: 20,
      intervalDuration: const Duration(seconds: 2),
    ).listen((Position position) {
      setState(() {
        _linhas.add(
            'Latitude: ${position.latitude} | Longitude: ${position.longitude}');
      });
      if (_ultimaPosicaoObtida != null) {
        final distancia = Geolocator.distanceBetween(
          _ultimaPosicaoObtida!.latitude,
          _ultimaPosicaoObtida!.longitude,
          position.latitude,
          position.longitude,
        );
        _distanciaTotalPercorrida += distancia;
        _linhas.add(
            'Distância total percorrida: ${_distanciaTotalPercorrida.toInt()}m');
      }
      _ultimaPosicaoObtida = position;
    });
  }

  void _pararMonitoramento() {
    _subscription?.cancel();
    setState(() {
      _subscription = null;
      _ultimaPosicaoObtida = null;
      _distanciaTotalPercorrida = 0;
    });
  }

  void _limparLog() {
    setState(() {
      _linhas.clear();
    });
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá '
          'habilitar o serviço de localização do dispositivo');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem(
            'Não será possível utilizar o recurso por falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem(
          'Para utilizar esse recurso, você deverá acessar as configurações '
          'do app e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem),
    ));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
