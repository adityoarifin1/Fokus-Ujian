import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../database/db_helper.dart';
import '../models/admin.dart';

class AdminRepository {
  Future<Admin?> getAdmin(String username) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'admin',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return Admin.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Admin?> validateLogin(String username, String passwordPlain) async {
    final admin = await getAdmin(username);
    if (admin != null) {
      final bytes = utf8.encode(passwordPlain);
      final hash = sha256.convert(bytes).toString();
      if (admin.passwordHash == hash) {
        return admin;
      }
    }
    return null;
  }

  Future<List<Admin>> getAllGuru() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      'admin',
      where: 'role = ?',
      whereArgs: ['guru'],
    );
    return maps.map((e) => Admin.fromMap(e)).toList();
  }

  Future<int> insertAdmin(Admin admin) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('admin', admin.toMap());
  }

  Future<int> updateAdmin(Admin admin) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'admin',
      admin.toMap(),
      where: 'id_admin = ?',
      whereArgs: [admin.idAdmin],
    );
  }

  Future<int> deleteAdmin(int idAdmin) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'admin',
      where: 'id_admin = ?',
      whereArgs: [idAdmin],
    );
  }
}
