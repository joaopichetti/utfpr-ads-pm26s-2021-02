import 'package:cadastro_contatos/model/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_contatos.db';
  static const _dbVersion = 2;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${Contato.nomeTabela} (
        ${Contato.campoId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Contato.campoNome} TEXT NOT NULL,
        ${Contato.campoTelefone} TEXT,
        ${Contato.campoEmail} TEXT,
        ${Contato.campoTipoImagem} TEXT NOT NULL,
        ${Contato.campoCaminhoImagem} TEXT,
        ${Contato.campoCaminhoVideo} TEXT
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch (oldVersion) {
      case 1:
        await db.execute('''
          ALTER TABLE ${Contato.nomeTabela} ADD COLUMN ${Contato.campoCaminhoVideo} TEXT;
        ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}
