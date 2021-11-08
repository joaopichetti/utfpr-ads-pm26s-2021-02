import 'package:cadastro_pontos_turisticos/database/fake_database.dart';
import 'package:cadastro_pontos_turisticos/model/ponto_turistico.dart';
import 'package:flutter/material.dart';

class FormPontoTuristicoPage extends StatefulWidget {
  final PontoTuristico? pontoTuristico;

  const FormPontoTuristicoPage({Key? key, this.pontoTuristico})
      : super(key: key);

  @override
  _FormPontoTuristicoPageState createState() => _FormPontoTuristicoPageState();
}

class _FormPontoTuristicoPageState extends State<FormPontoTuristicoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _database = FakeDatabase.instance;
  var _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.pontoTuristico != null) {
      _nomeController.text = widget.pontoTuristico!.nome;
      _descricaoController.text = widget.pontoTuristico!.descricao ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar() {
    final String title;
    if (widget.pontoTuristico == null) {
      title = 'Novo Ponto Turístico';
    } else {
      title = 'Alterar Ponto Turístico';
    }
    final Widget titleWidget;
    if (_salvando) {
      titleWidget = Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(title);
    }
    return AppBar(
      title: titleWidget,
      actions: [
        if (!_salvando)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _salvar,
          ),
      ],
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Código',
              ),
              initialValue: widget.pontoTuristico?.id?.toString(),
              readOnly: true,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              controller: _nomeController,
              validator: (String? valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe o nome';
                }
                return null;
              },
              readOnly: _salvando,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descrição',
              ),
              controller: _descricaoController,
              readOnly: _salvando,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final novoPontoTuristico = PontoTuristico(
      id: widget.pontoTuristico?.id,
      nome: _nomeController.text,
      descricao: _descricaoController.text,
    );
    setState(() {
      _salvando = true;
    });
    await _database.salvar(novoPontoTuristico);
    setState(() {
      _salvando = false;
    });
    Navigator.of(context).pop(true);
  }
}
