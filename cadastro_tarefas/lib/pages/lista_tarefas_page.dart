import 'package:cadastro_tarefas/dao/tarefa_dao.dart';
import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:cadastro_tarefas/pages/detalhes_tarefa_page.dart';
import 'package:cadastro_tarefas/pages/filtro_page.dart';
import 'package:cadastro_tarefas/widgets/conteudo_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaTarefasPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  static const acaoEditar = 'editar';
  static const acaoExcluir = 'excluir';
  static const acaoVisualizar = 'visualizar';

  final _tarefas = <Tarefa>[];
  final _dao = TarefaDao();
  var _carregando = false;

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
    if (_carregando) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Carregando suas tarefas',
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
            leading: Checkbox(
              value: tarefa.finalizada,
              onChanged: (bool? checked) {
                setState(() {
                  tarefa.finalizada = checked == true;
                });
                _dao.salvar(tarefa);
              },
            ),
            title: Text(
              '${tarefa.id} - ${tarefa.descricao}',
              style: TextStyle(
                decoration:
                    tarefa.finalizada ? TextDecoration.lineThrough : null,
                color: tarefa.finalizada ? Colors.grey : null,
              ),
            ),
            subtitle: Text(
              tarefa.prazoFormatado,
              style: TextStyle(
                decoration:
                    tarefa.finalizada ? TextDecoration.lineThrough : null,
                color: tarefa.finalizada ? Colors.grey : null,
              ),
            ),
          ),
          itemBuilder: (_) => _criarItensMenuPopup(),
          onSelected: (String valorSelecionado) {
            if (valorSelecionado == acaoEditar) {
              _abrirForm(tarefa: tarefa);
            } else if (valorSelecionado == acaoExcluir) {
              _excluir(tarefa);
            } else {
              _abrirPaginaDetalhesTarefa(tarefa);
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
            children: const [
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
            children: const [
              Icon(Icons.delete, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: acaoVisualizar,
          child: Row(
            children: const [
              Icon(Icons.info, color: Colors.blue),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Visualizar'),
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
      _atualizarLista();
    }
  }

  void _abrirPaginaDetalhesTarefa(Tarefa tarefa) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesTarefaPage(
            tarefa: tarefa,
          ),
        ));
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    // Carregar os valores do SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.chaveCampoOrdenacao) ?? Tarefa.campoId;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.chaveUsarOrdemDecrescente) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.chaveFiltroDescricao) ?? '';
    final tarefas = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _carregando = false;
      _tarefas.clear();
      if (tarefas.isNotEmpty) {
        _tarefas.addAll(tarefas);
      }
    });
  }
}
