import 'package:cadastro_pontos_turisticos/database/fake_database.dart';
import 'package:cadastro_pontos_turisticos/model/ponto_turistico.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  final _favoritos = <PontoTuristico>[];
  var _carregando = false;
  final _database = FakeDatabase.instance;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() {
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Carregando favoritos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (_favoritos.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum ponto turístico favorito',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _favoritos.length,
      itemBuilder: (_, index) {
        final pontoTuristico = _favoritos[index];
        return ListTile(
          title: Text('${pontoTuristico.id} - ${pontoTuristico.nome}'),
          subtitle: Text(
            pontoTuristico.descricao ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  Future<void> _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    final favoritos = await _database.listarFavoritos();
    setState(() {
      _carregando = false;
      _favoritos.clear();
      if (favoritos.isNotEmpty) {
        _favoritos.addAll(favoritos);
      }
    });
  }
}
