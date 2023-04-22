import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entidades/pedidos.dart';
import '../entidades/usuarios.dart';

class OperacionesPedido {
  static Future<Database> openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'orderTable.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE orderTable(id INTEGER PRIMARY KEY AUTOINCREMENT, idUsuario INTEGER, listaProductos TEXT)');
    }, version: 1);
  }

  static Future<void> insertPedido(Pedidos p) async {
    Database db = await openDB();
    db.insert('orderTable', p.toMap());
  }

  static Future<void> deletePedido(Pedidos p) async {
    Database db = await openDB();
    db.delete('orderTable', where: 'id = ?', whereArgs: [p.id]);
  }

  static Future<void> updatePedido(Pedidos p) async {
    Database db = await openDB();
    db.update('orderTable', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  static Future<List<Pedidos>> getPedidos() async {
    Database db = await openDB();
    final List<Map<String, dynamic>> pedidosMap = await db.query('orderTable');

    return List.generate(
        pedidosMap.length,
        (i) => Pedidos(
            id: pedidosMap[i]['id'],
            idUsuario: pedidosMap[i]['idUsuario'],
            listaProductos: (pedidosMap[i]['listaProductos'])));
  }

  //////////////////////////////////////////////////////////////////////////////

  static Future<List<Pedidos>> getPedidosFromUser(int idUser) async {
    List<Pedidos> pedidos = await getPedidos();
    List<Pedidos> aux = <Pedidos>[];
    for (int i = 0; i < pedidos.length; i++) {
      if (pedidos[i].idUsuario == idUser) {
        aux.add(pedidos[i]);
      }
    }
    return aux;
  }

  static Future<List<Pedidos>> pedidosFromFutureUser(
      Future<Usuarios> fUser) async {
    Usuarios user = await fUser;
    return getPedidosFromUser(user.id);
  }
}
