import 'package:cadastro_tarefas/dao/tarefa_dao.dart';
import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:cadastro_tarefas/pages/filtro_page.dart';
import 'package:cadastro_tarefas/widgets/conteudo_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListaTarefasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  static const acaoEditar = 'editar';
  static const acaoExcluir = 'excluir';

  final _tarefas = <Tarefa>[];
  final _dao = TarefaDao();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova Tarefa',
        child: Icon(Icons.add),
        onPressed: _abrirForm,
      ),
    );
  }

  AppBar _criarAppBar() {
    return AppBar(
      title: Text('Tarefas'),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          tooltip: 'Filtro e Ordenação',
          onPressed: _abrirPaginaFiltro,
        ),
      ],
    );
  }

  Widget _criarBody() {
    if (_tarefas.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma tarefa cadastrada',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _tarefas.length,
      itemBuilder: (BuildContext context, int index) {
        final tarefa = _tarefas[index];
        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${tarefa.id} - ${tarefa.descricao}'),
            subtitle: Text(tarefa.prazoFormatado),
          ),
          itemBuilder: (_) => _criarItensMenuPopup(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == acaoEditar) {
              _abrirForm(tarefa: tarefa);
            } else {
              _excluir(tarefa);
            }
          },
        );
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }

  List<PopupMenuEntry<String>> _criarItensMenuPopup() => [
        PopupMenuItem(
          value: acaoEditar,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: acaoExcluir,
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              ),
            ],
          ),
        ),
      ];

  void _abrirForm({Tarefa? tarefa}) {
    final key = GlobalKey<ConteudoDialogFormState>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          tarefa == null ? 'Nova Tarefa' : 'Alterar Tarefa ${tarefa.id}',
        ),
        content: ConteudoDialogForm(
          key: key,
          tarefa: tarefa,
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Salvar'),
            onPressed: () {
              if (key.currentState?.dadosValidos() != true) {
                return;
              }
              Navigator.of(context).pop();
              final novaTarefa = key.currentState!.novaTarefa;
              _dao.salvar(novaTarefa).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _excluir(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Atenção'),
            ),
          ],
        ),
        content: Text('Esse registro será removido definitivamente.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              if (tarefa.id == null) {
                return;
              }
              _dao.remover(tarefa.id!).then((success) {
                if (success) {
                  _atualizarLista();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  void _abrirPaginaFiltro() async {
    final navigator = Navigator.of(context);
    final alterouValores = await navigator.pushNamed(FiltroPage.routeName);
    if (alterouValores == true) {
      // TODO
    }
  }

  void _atualizarLista() async {
    final tarefas = await _dao.listar();
    setState(() {
      _tarefas.clear();
      if (tarefas.isNotEmpty) {
        _tarefas.addAll(tarefas);
      }
    });
  }
}
