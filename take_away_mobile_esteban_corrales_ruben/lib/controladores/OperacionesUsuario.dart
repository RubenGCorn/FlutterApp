import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entidades/usuarios.dart';

class OperacionesUsuario {
  static Future<Database> openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'users.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, idRol INTEGER, nombre TEXT, email TEXT, pass TEXT)');
    }, version: 1);
  }

  static Future<void> insertUser(Usuarios u) async {
    Database db = await openDB();
    db.insert('users', u.toMap());
  }

  static Future<void> deleteUser(Usuarios u) async {
    Database db = await openDB();
    db.delete('users', where: 'id = ?', whereArgs: [u.id]);
  }

  static Future<void> updateUser(Usuarios u) async {
    Database db = await openDB();
    db.update('users', u.toMap(), where: 'id = ?', whereArgs: [u.id]);
  }

  static Future<List<Usuarios>> getPersonas() async {
    Database db = await openDB();
    final List<Map<String, dynamic>> personasMap = await db.query('users');

    return List.generate(
        personasMap.length,
        (i) => Usuarios(
            id: personasMap[i]['id'],
            nombre: personasMap[i]['nombre'],
            email: personasMap[i]['email'],
            pass: personasMap[i]['pass'],
            idRol: personasMap[i]['idRol']));
  }

  //////////////////////////////////////////////////////////////////////////////

  static Future<bool> existsUser(String mail) async {
    List<Usuarios> lista = await getPersonas();
    bool exists = false;
    for (int i = 0; i < lista.length; i++) {
      if (lista[i].email == mail) {
        exists = true;
      }
    }

    return exists;
  }

  static Future<Usuarios> getUser(String mail) async {
    List<Usuarios> lista = await getPersonas();
    late Usuarios user;

    for (int i = 0; i < lista.length; i++) {
      if (lista[i].email == mail) {
        user = lista[i];
      }
    }
    return user;
  }
}
