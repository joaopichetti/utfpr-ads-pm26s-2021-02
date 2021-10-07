import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget {
  static const routeName = '/filtro';
  static const chaveCampoOrdenacao = 'campoOrdenacao';
  static const chaveUsarOrdemDecrescente = 'usarOrdemDecrescente';
  static const chaveFiltroDescricao = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage> {
  final _camposParaOrdenacao = {
    Tarefa.campoId: 'Código',
    Tarefa.campoDescricao: 'Descrição',
    Tarefa.campoPrazo: 'Prazo'
  };
  late final SharedPreferences _prefs;
  final _descricaoController = TextEditingController();
  String _campoOrdenacao = Tarefa.campoId;
  bool _usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregarSharedPreferences();
  }

  void _carregarSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _campoOrdenacao =
          _prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? Tarefa.campoId;
      _usarOrdemDecrescente =
          _prefs.getBool(FiltroPage.chaveUsarOrdemDecrescente) == true;
      _descricaoController.text =
          _prefs.getString(FiltroPage.chaveFiltroDescricao) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro e Ordenação'),
      ),
    );
  }
}
