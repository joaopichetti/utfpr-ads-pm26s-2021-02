import 'package:cadastro_contatos/dao/contato_dao.dart';
import 'package:cadastro_contatos/model/contato.dart';
import 'package:cadastro_contatos/pages/form_contato_page.dart';
import 'package:cadastro_contatos/widgets/visualizador_imagem.dart';
import 'package:flutter/material.dart';

class ListaContatosPage extends StatefulWidget {
  const ListaContatosPage({Key? key}) : super(key: key);

  @override
  _ListaContatosPageState createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  final _contatos = <Contato>[];
  final _dao = ContatoDao();
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
        title: const Text('Contatos'),
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
                'Carregando contatos',
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
    if (_contatos.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum contato cadastrado',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _contatos.length,
      itemBuilder: (_, index) {
        final contato = _contatos[index];
        return ListTile(
          leading: VisualizadorImagem(
            tipoImagem: contato.tipoImagem,
            caminhoImagem: contato.caminhoImagem,
          ),
          title: Text(contato.nome),
          subtitle: Row(
            children: [
              if (contato.telefone?.isNotEmpty == true)
                Expanded(
                  child: Text(contato.telefone!),
                ),
              if (contato.email?.isNotEmpty == true)
                Expanded(
                  child: Text(contato.email!),
                ),
            ],
          ),
          onTap: () => _mostrarDialogAcoes(contato),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  void _mostrarDialogAcoes(Contato contato) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contato.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                _abrirForm(contato: contato);
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
                _excluir(contato);
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

  void _abrirForm({Contato? contato}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FormContatoPage(contato: contato),
        )).then((alterou) {
      if (alterou == true) {
        _atualizarLista();
      }
    });
  }

  void _excluir(Contato contato) {
    if (contato.id == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Atenção'),
        content: Text(
          'O registro "${contato.nome}" '
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
              _dao.remover(contato.id!).then((_) {
                _atualizarLista();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _atualizarLista() async {
    setState(() {
      _carregando = true;
    });
    final lista = await _dao.listar();
    setState(() {
      _carregando = false;
      _contatos.clear();
      if (lista.isNotEmpty) {
        _contatos.addAll(lista);
      }
    });
  }
}
