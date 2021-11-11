import 'package:cadastro_contatos/database/database_provider.dart';
import 'package:cadastro_contatos/model/contato.dart';

class ContatoDao {
  final databaseProvider = DatabaseProvider.instance;

  Future<bool> salvar(Contato tarefa) async {
    final database = await databaseProvider.database;
    final valores = tarefa.toMap();
    if (tarefa.id == null) {
      tarefa.id = await database.insert(Contato.nomeTabela, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        Contato.nomeTabela,
        valores,
        where: '${Contato.campoId} = ?',
        whereArgs: [tarefa.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final database = await databaseProvider.database;
    final registrosAtualizados = await database.delete(
      Contato.nomeTabela,
      where: '${Contato.campoId} = ?',
      whereArgs: [id],
    );
    return registrosAtualizados > 0;
  }

  Future<List<Contato>> listar() async {
    final database = await databaseProvider.database;
    final resultado = await database.query(
      Contato.nomeTabela,
      columns: [
        Contato.campoId,
        Contato.campoNome,
        Contato.campoTelefone,
        Contato.campoEmail,
        Contato.campoTipoImagem,
        Contato.campoCaminhoImagem,
      ],
    );
    return resultado.map((m) => Contato.fromMap(m)).toList();
  }
}
