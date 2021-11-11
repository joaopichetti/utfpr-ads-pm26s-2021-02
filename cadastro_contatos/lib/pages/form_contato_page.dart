import 'package:cadastro_contatos/dao/contato_dao.dart';
import 'package:cadastro_contatos/model/contato.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormContatoPage extends StatefulWidget {
  final Contato? contato;

  const FormContatoPage({Key? key, this.contato}) : super(key: key);

  @override
  _FormContatoPageState createState() => _FormContatoPageState();
}

class _FormContatoPageState extends State<FormContatoPage> {
  final _formKey = GlobalKey<FormState>();
  final _dao = ContatoDao();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneFormatter = MaskTextInputFormatter(
    mask: '(##) ?####-####',
    filter: {'#': RegExp(r'[0-9]'), '?': RegExp(r'[0-9]?')},
  );
  var _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone ?? '';
      _emailController.text = widget.contato!.email ?? '';
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
    if (widget.contato == null) {
      title = 'Novo Contato';
    } else {
      title = 'Alterar Contato';
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
                labelText: 'Telefone',
              ),
              controller: _telefoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [_telefoneFormatter],
              readOnly: _salvando,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
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
    final novoContato = Contato(
      id: widget.contato?.id,
      nome: _nomeController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
    );
    setState(() {
      _salvando = true;
    });
    await _dao.salvar(novoContato);
    setState(() {
      _salvando = false;
    });
    Navigator.of(context).pop(true);
  }
}
