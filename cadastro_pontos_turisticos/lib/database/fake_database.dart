import 'dart:async';

import 'package:cadastro_pontos_turisticos/model/ponto_turistico.dart';

class FakeDatabase {
  static final _instance = FakeDatabase._init();

  FakeDatabase._init();

  static FakeDatabase get instance => _instance;

  final List<PontoTuristico> _pontosTuristicos = [];
  int _ultimoId = 0;
  final _delay = const Duration(milliseconds: 500);

  Future<List<PontoTuristico>> listar() async {
    await Future.delayed(_delay);
    return _pontosTuristicos;
  }

  Future<List<PontoTuristico>> listarFavoritos() async {
    await Future.delayed(_delay);
    return _pontosTuristicos.where((p) => p.favorito).toList();
  }

  Future<void> salvar(PontoTuristico pontoTuristico) async {
    await Future.delayed(_delay);
    if (pontoTuristico.id == null) {
      pontoTuristico.id = ++_ultimoId;
      _pontosTuristicos.add(pontoTuristico);
    } else {
      final index =
          _pontosTuristicos.indexWhere((p) => p.id == pontoTuristico.id);
      if (index >= 0) {
        _pontosTuristicos[index] = pontoTuristico;
      }
    }
  }

  Future<void> remover(int id) async {
    await Future.delayed(_delay);
    _pontosTuristicos.removeWhere((p) => p.id == id);
  }
}
