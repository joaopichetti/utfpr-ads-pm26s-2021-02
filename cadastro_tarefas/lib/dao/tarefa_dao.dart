import 'package:cadastro_tarefas/database/database_provider.dart';
import 'package:cadastro_tarefas/model/tarefa.dart';

class TarefaDao {
  final databaseProvider = DatabaseProvider.instance;

  Future<bool> salvar(Tarefa tarefa) async {
    final database = await databaseProvider.database;
    final valores = tarefa.toMap();
    if (tarefa.id == null) {
      tarefa.id = await database.insert(Tarefa.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        Tarefa.nomeTabela,
        valores,
        where: '${Tarefa.campoId} = ?',
        whereArgs: [tarefa.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      Tarefa.nomeTabela,
      where: '${Tarefa.campoId} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<Tarefa>> listar({
    String filtro = '',
    String campoOrdenacao = Tarefa.campoId,
    bool usarOrdemDecrescente = false,
  }) async {
    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(${Tarefa.campoDescricao}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }
    final database = await databaseProvider.database;
    final resultado = await database.query(
      Tarefa.nomeTabela,
      columns: [Tarefa.campoId, Tarefa.campoDescricao, Tarefa.campoPrazo],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}
