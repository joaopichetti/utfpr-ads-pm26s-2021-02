import 'package:intl/intl.dart';

class Tarefa {
  static const nomeTabela = 'tarefa';
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

  Map<String, dynamic> toMap() => {
        campoId: id,
        campoDescricao: descricao,
        campoPrazo:
            prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
      };

  factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
        id: map[campoId] is int ? map[campoId] : null,
        descricao: map[campoDescricao] is String ? map[campoDescricao] : '',
        prazo: map[campoPrazo] is String
            ? DateFormat("yyyy-MM-dd").parse(map[campoPrazo])
            : null,
      );
}
