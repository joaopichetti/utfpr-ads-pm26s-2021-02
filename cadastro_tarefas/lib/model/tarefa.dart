import 'package:intl/intl.dart';

class Tarefa {

  int id;
  String descricao;
  DateTime? prazo;

  Tarefa({required this.id, required this.descricao, this.prazo});

  String get prazoFormatado {
    if (prazo == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

}