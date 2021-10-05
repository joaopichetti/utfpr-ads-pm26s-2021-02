import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:cadastro_tarefas/widgets/conteudo_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListaTarefasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  final _tarefas = [
    Tarefa(
      id: 1,
      descricao: 'Fazer exercício 1',
      prazo: DateTime.now().add(Duration(days: 5)),
    ),
  ];
  var _ultimoId = 1;

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
          onPressed: () {},
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
        return ListTile(
          title: Text('${tarefa.id} - ${tarefa.descricao}'),
          subtitle: Text(tarefa.prazoFormatado),
        );
      },
      separatorBuilder: (_, __) => Divider(),
    );
  }

  void _abrirForm({Tarefa? tarefa, int? index}) {
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Salvar'),
            onPressed: () {
              if (key.currentState?.dadosValidos() != true) {
                return;
              }
              final novaTarefa = key.currentState!.novaTarefa;
              if (index == null) {
                novaTarefa.id = ++_ultimoId;
                _tarefas.add(novaTarefa);
              } else {
                _tarefas[index] = novaTarefa;
              }
              // Atualiza a interface
              setState(() {});
              // Fecha o Dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
