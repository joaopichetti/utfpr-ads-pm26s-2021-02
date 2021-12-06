import 'package:flutter/material.dart';
import 'package:test_api/pages/consulta_cep_fragment.dart';
import 'package:test_api/pages/lista_cidades_fragment.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  var _fragmentIndex = 0;
  final _listaCidadesKey = GlobalKey<ListaCidadesFragmentState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_fragmentIndex == 0
            ? ConsultaCepFragment.title : ListaCidadesFragment.title),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _fragmentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: ConsultaCepFragment.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: ListaCidadesFragment.title,
          ),
        ],
        onTap: (int newIndex) {
          if (newIndex != _fragmentIndex) {
            setState(() {
              _fragmentIndex = newIndex;
            });
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() => _fragmentIndex == 0
      ? ConsultaCepFragment() : ListaCidadesFragment(key: _listaCidadesKey);

  Widget? _buildFloatingActionButton() {
    if (_fragmentIndex == 0) {
      return null;
    }
    return FloatingActionButton(
      child: const Icon(Icons.add),
      tooltip: 'Cadastrar Cidade',
      onPressed: () => _listaCidadesKey.currentState?.abrirForm(),
    );
  }

}