import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "ExemploDB.db";
  static final _databaseVersion = 1;
  static final table = 'contato';
  static final columId = '_id';
  static final columNome = 'nome';
  static final columIdade = 'idade';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referencia ao banco de dados
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  //abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  //Codigo SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    await db.execute(''' CREATE TABLE $table (
      $columId INTEGER PRIMARY KEY,
      $columNome TEXT NOT NULL,
      $columIdade INTEGER NOT NULL)
      ''');
  }

  // metodos Helper
//----------------------------------------------------------------
// insere uma linha no banco de dados onde cada chave
// no Map é um nome de coluna e o valor é o valor da coluna.
// o valor de retorno é o ID da linha inserida.

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

// Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
// uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

// Todos os métodos: inserir, consultar, atualizar e excluir,
// também podem ser feitos usando comandos SQL brutos.
// Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // Valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columId];
    return await db.update(table, row, where: '$columId = ?', whereArgs: [id]);
  }

  // Exclui a linha especifica pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contato que a linha existia.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columId = ?', whereArgs: [id]);
  }
}
