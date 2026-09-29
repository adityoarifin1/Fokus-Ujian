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

  Future<Admin?> validateLogin(String username, String passwordHash) async {
    final admin = await getAdmin(username);
    if (admin != null && admin.passwordHash == passwordHash) {
      return admin;
    }
    return null;
  }
}
