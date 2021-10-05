import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConteudoDialogForm extends StatefulWidget {
  Tarefa? tarefa;

  ConteudoDialogForm({Key? key, Tarefa? tarefa}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConteudoDialogFormState();
}

class ConteudoDialogFormState extends State<ConteudoDialogForm> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _prazoController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _descricaoController.text = widget.tarefa!.descricao;
      _prazoController.text = widget.tarefa!.prazoFormatado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição',
            ),
            validator: (String? valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Informe a descrição';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _prazoController,
            decoration: InputDecoration(
              labelText: 'Prazo',
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: _mostrarCalendario,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _prazoController.clear(),
              ),
            ),
            readOnly: true,
          ),
        ],
      ),
    );
  }

  void _mostrarCalendario() async {
    final dataFormatada = _prazoController.text;
    DateTime data;
    if (dataFormatada.trim().isNotEmpty) {
      data = _dateFormat.parse(dataFormatada);
    } else {
      data = DateTime.now();
    }
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: data,
      firstDate: DateTime.now().subtract(Duration(days: 5 * 365)),
      lastDate: DateTime.now().add(Duration(days: 5 * 365)),
    );
    if (dataSelecionada != null) {
      _prazoController.text = _dateFormat.format(dataSelecionada);
    }
  }

  bool dadosValidos() => _formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
        id: widget.tarefa?.id,
        descricao: _descricaoController.text,
        prazo: _prazoController.text.isEmpty
            ? null
            : _dateFormat.parse(_prazoController.text),
      );
}
