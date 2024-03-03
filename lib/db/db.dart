import 'dart:async';
import 'package:accountary/db/models/Transaction.dart';
import 'package:accountary/db/models/Race.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY,
        race_id INTEGER NOT NULL,
        type INTEGER NOT NULL,
        amount INTEGER NOT NULL,
        title text NOT NULL,
        description TEXT NULL,
        date TEXT NOT NULL
      )
''');
      await db.execute('''
      CREATE TABLE races (
        id INTEGER PRIMARY KEY
      )
''');
    });
  }

  Future<List<RaceTransaction>> getTransactions() async {
    final List<Map<String, dynamic>> transactionsMapList =
        await db.query("transactions");
    final List<RaceTransaction> transactionsList = [];
    transactionsMapList.forEach((element) {
      transactionsList.add(RaceTransaction.fromMap(element));
    });
    return transactionsList;
  }

  Future<RaceTransaction> insertTransaction(RaceTransaction transaction) async {
    transaction.id = await db.insert('transactions', transaction.toMap());
    return transaction;
  }

  Future<int> daleteTransaction(int id) async {
    return await db.delete('transactions', where: "id = ?", whereArgs: [id]);
  }

  Future<List<Race>> getRaces(Race race) async {
    final List<Map<String, dynamic>> racesMapList = await db.query("races");
    final List<Race> racesList = [];
    racesMapList.forEach((element) {
      racesList.add(Race.fromMap(element));
    });
    return racesList;
  }

  Future<Race> insertRace(Race race) async {
    race.id = await db.insert('races', race.toMap());
    return race;
  }
}
