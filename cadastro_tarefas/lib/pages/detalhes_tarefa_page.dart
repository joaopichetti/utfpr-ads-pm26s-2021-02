import 'package:cadastro_tarefas/model/tarefa.dart';
import 'package:flutter/material.dart';

class DetalhesTarefaPage extends StatefulWidget {
  final Tarefa tarefa;

  const DetalhesTarefaPage({Key? key, required this.tarefa}) : super(key: key);

  @override
  _DetalhesTarefaPageState createState() => _DetalhesTarefaPageState();
}

class _DetalhesTarefaPageState extends State<DetalhesTarefaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Tarefa'),
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() => Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Campo(descricao: 'Código: '),
                Valor(valor: '${widget.tarefa.id}'),
              ],
            ),
            Row(
              children: [
                Campo(descricao: 'Descrição: '),
                Valor(valor: widget.tarefa.descricao),
              ],
            ),
            Row(
              children: [
                Campo(descricao: 'Prazo: '),
                Valor(valor: widget.tarefa.prazoFormatado),
              ],
            ),
            Row(
              children: [
                Campo(descricao: 'Finalizada: '),
                Valor(valor: widget.tarefa.finalizada ? 'Sim' : 'Não'),
              ],
            ),
          ],
        ),
      );
}

class Campo extends StatelessWidget {
  final String descricao;

  const Campo({Key? key, required this.descricao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Text(
        descricao,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Valor extends StatelessWidget {
  final String valor;

  const Valor({Key? key, required this.valor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}
