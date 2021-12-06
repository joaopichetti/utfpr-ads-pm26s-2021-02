import 'package:flutter/material.dart';
import 'package:test_api/model/cidade.dart';
import 'package:test_api/services/cidade_service.dart';

class FormCidadePage extends StatefulWidget {
  final Cidade? cidade;

  const FormCidadePage({this.cidade});

  @override
  State<StatefulWidget> createState() => _FormCidadePageState();
}

class _FormCidadePageState extends State<FormCidadePage> {
  final _service = CidadeService();
  var _saving = false;
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String? _currentUf;

  @override
  void initState() {
    super.initState();
    if (widget.cidade != null) {
      _nomeController.text = widget.cidade!.nome;
      _currentUf = widget.cidade!.uf;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    final String title;
    if (widget.cidade == null) {
      title = 'Nova Cidade';
    } else {
      title = 'Alterar Cidade';
    }
    final Widget titleWidget;
    if (_saving) {
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
        if (!_saving)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
      ],
    );
  }

  Widget _buildBody() => Padding(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.cidade?.codigo != null)
              Text('Código: ${widget.cidade!.codigo}'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              controller: _nomeController,
              validator: (String? newValue) {
                if (newValue == null || newValue.trim().isEmpty) {
                  return 'Informe o nome';
                }
                return null;
              }
            ),
            DropdownButtonFormField(
              value: _currentUf,
              decoration: const InputDecoration(
                labelText: 'UF',
              ),
              items: _buildDropdownItems(),
              onChanged: (String? newValue) {
                setState(() {
                  _currentUf = newValue;
                });
              },
              validator: (String? newValue) {
                if (newValue == null || newValue.trim().isEmpty) {
                  return 'Selecione a UF';
                }
                return null;
              }
            ),
          ],
        ),
      ),
    ),
  );

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    const ufs = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA',
      'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO',
      'RR', 'SC', 'SP', 'SE', 'TO'];
    final List<DropdownMenuItem<String>> items = [];
    for (final uf in ufs) {
      items.add(DropdownMenuItem<String>(
        value: uf,
        child: Text(uf),
      ));
    }
    return items;
  }

  Future<void> _save() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _saving = true;
    });
    try {
      await _service.saveCidade(Cidade(
        codigo: widget.cidade?.codigo,
        nome: _nomeController.text,
        uf: _currentUf!,
      ));
      Navigator.pop(context, true);
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Não foi possível salvar a cidade. Tente novamente.'),
      ));
    }
    setState(() {
      _saving = false;
    });
  }
}