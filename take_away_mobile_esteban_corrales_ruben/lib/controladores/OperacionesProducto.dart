import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../entidades/productos.dart';

class OperacionesProducto {
  static Future<Database> openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'product.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, descripcion TEXT, imagen TEXT, precio DOUBLE)');
    }, version: 1);
  }

  static Future<void> insertProducto(Productos p) async {
    Database db = await openDB();
    db.insert('product', p.toMap());
  }

  static Future<void> deleteProductos(Productos p) async {
    Database db = await openDB();
    db.delete('product', where: 'id = ?', whereArgs: [p.id]);
  }

  static Future<void> updateProductos(Productos p) async {
    Database db = await openDB();
    db.update('product', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  static Future<List<Productos>> getProductos() async {
    Database db = await openDB();
    final List<Map<String, dynamic>> productosMap = await db.query('product');

    return List.generate(
        productosMap.length,
        (i) => Productos(
            id: productosMap[i]['id'],
            nombre: productosMap[i]['nombre'],
            descripcion: productosMap[i]['descripcion'],
            imagen: productosMap[i]['imagen'],
            precio: productosMap[i]['precio']));
  }

  //////////////////////////////////////////////////////////////////////////////

  Future<Productos> getProductoById(int id) async {
    final List<Productos> productos = await getProductos();
    Productos p = productos[0];
    for (int i = 0; i < productos.length; i++) {
      if (productos[i].id == id) {
        p = productos[i];
      }
    }
    return p;
  }
}
