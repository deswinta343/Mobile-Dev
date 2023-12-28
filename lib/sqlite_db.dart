import 'package:flutter_application_1/model/foto.dart';
import 'package:flutter_application_1/model/buku.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'dart:async';

class SQLHelper {
  static Future<sql.Database> db() async {
    return await sql.openDatabase("catatan.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE buku(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT,
        photo TEXT
      )
    ''');

    await database.execute('''
      CREATE TABLE foto(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        judul TEXT,
        deskripsi TEXT,
        photo TEXT
      )
    ''');
  }

  static Future<int> tambahBuku(Buku buku) async {
    final db = await SQLHelper.db();
    final data = buku.toList();
    return await db.insert('buku', data);
  }

  static Future<void> tambahFoto(Foto foto) async {
    final db = await SQLHelper.db();
    final data = foto.toList();
    await db.insert('foto', data);
  }

  static Future<List<Map<String, dynamic>>> getBuku() async {
    final db = await SQLHelper.db();
    return db.query("buku");
  }

  static Future<int> updateBuku(Buku buku) async {
    final db = await SQLHelper.db();
    final data = buku.toList();
    return await db.update('buku', data, where: "id=?", whereArgs: [buku.id]);
  }

  static Future<int> deleteBuku(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('buku', where: 'id=?', whereArgs: [id]);
  }

  static Future<int> deleteFoto(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('foto', where: 'id=?', whereArgs: [id]);
  }
}