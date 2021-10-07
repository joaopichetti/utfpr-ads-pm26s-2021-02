import 'package:intl/intl.dart';

class Tarefa {
  static const campoId = '_id';
  static const campoDescricao = 'descricao';
  static const campoPrazo = 'prazo';

  int? id;
  String descricao;
  DateTime? prazo;

  Tarefa({this.id, required this.descricao, this.prazo});

  String get prazoFormatado {
    if (prazo == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }
}
