import 'package:cadastro_pontos_turisticos/database/fake_database.dart';
import 'package:cadastro_pontos_turisticos/model/ponto_turistico.dart';
import 'package:cadastro_pontos_turisticos/pages/favoritos_page.dart';
import 'package:cadastro_pontos_turisticos/pages/form_ponto_turistico_page.dart';
import 'package:flutter/material.dart';

class ListaPontosTuristicosPage extends StatefulWidget {
  const ListaPontosTuristicosPage({Key? key}) : super(key: key);

  @override
  _ListaPontosTuristicosPageState createState() =>
      _ListaPontosTuristicosPageState();
}

class _ListaPontosTuristicosPageState extends State<ListaPontosTuristicosPage> {
  final _pontosTuristicos = <PontoTuristico>[];
  final _database = FakeDatabase.instance;
  var _carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pontos Turísticos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _abrirFavoritos,
            tooltip: 'Favoritos',
          ),
        ],
      ),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _abrirForm,
      ),
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
                'Carregando pontos turísticos',
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
    if (_pontosTuristicos.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum ponto turístico cadastrado',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _pontosTuristicos.length,
      itemBuilder: (_, index) {
        final pontoTuristico = _pontosTuristicos[index];
        return ListTile(
          leading: IconButton(
            icon: Icon(pontoTuristico.favorito
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () => _modificarFavorito(pontoTuristico),
          ),
          title: Text('${pontoTuristico.id} - ${pontoTuristico.nome}'),
          subtitle: Text(
            pontoTuristico.descricao ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => _mostrarDialogAcoes(pontoTuristico),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  void _mostrarDialogAcoes(PontoTuristico pontoTuristico) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${pontoTuristico.id} - ${pontoTuristico.nome}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _abrirForm(pontoTuristico: pontoTuristico);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Excluir'),
              onTap: () {
                Navigator.pop(context);
                _excluir(pontoTuristico);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _abrirForm({PontoTuristico? pontoTuristico}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => FormPontoTuristicoPage(pontoTuristico: pontoTuristico),
    )).then((alterou) {
      if (alterou == true) {
        _atualizarLista();
      }
    });
  }

  void _excluir(PontoTuristico pontoTuristico) {
    if (pontoTuristico.id == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(
          'O registro "${pontoTuristico.id} - ${pontoTuristico.nome}" '
          'será removido definitivamente.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              _database.remover(pontoTuristico.id!).then((_) {
                _atualizarLista();
              });
            },
          ),
        ],
      ),
    );
  }

  void _abrirFavoritos() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const FavoritosPage(),
    ));
  }

  void _modificarFavorito(PontoTuristico pontoTuristico) {
    setState(() {
      pontoTuristico.favorito = !pontoTuristico.favorito;
    });
  }

  Future<void> _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    final lista = await _database.listar();
    setState(() {
      _carregando = false;
      _pontosTuristicos.clear();
      if (lista.isNotEmpty) {
        _pontosTuristicos.addAll(lista);
      }
    });
  }
}
