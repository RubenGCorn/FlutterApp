import 'package:firebase_database/firebase_database.dart';

import '../entidades/pedidos.dart';
import '../entidades/productos.dart';
import '../entidades/usuarios.dart';
import 'OperacionesPedido.dart';
import 'OperacionesProducto.dart';
import 'OperacionesUsuario.dart';

class Servicios {
  static var dbRef = FirebaseDatabase.instance.ref().child("productos");

  static Future<List<Object>> getDatosPedido(Map<int, int> mapa) async {
    List<Object> lista = <Object>[];

    int id = await asignarIdPedido();
    lista.add(id);

    String detalles = await detallesPedido(mapa);
    lista.add(detalles);

    double total = await getTotalPedido(mapa);
    lista.add(total);

    return lista;
  }

  static Future<double> getTotalPedido(Map<int, int> mapa) async {
    double acumulado = 0;
    final data = await dbRef.once(DatabaseEventType.value);
    final datos = data.snapshot.value as Map;
    print("AQUI LOS DATOOOOOOOS: " + datos.toString());
    Iterable<int> ks = mapa.keys;
    Iterable<dynamic> mapaProd = datos.values;
    List<Productos> listaProductos = mapToListProducto(mapaProd);
    Productos p;

    for (final id in ks) {
      for (Productos prod in listaProductos) {
        if (prod.id == id) {
          p = prod;
          acumulado += (p.precio * mapa[id]!);
        }
      }
    }

    return acumulado;
  }

  static Future<int> asignarIdPedido() async {
    List<Pedidos> pedidos = await OperacionesPedido.getPedidos();
    int max = -1;
    for (Pedidos p in pedidos) {
      if (p.id > max) {
        max = p.id;
      }
    }
    return max + 1;
  }

  static Future<String> detallesPedido(Map<int, int> mapa) async {
    String resultado = '';
    final data = await dbRef.once(DatabaseEventType.value);
    final datos = data.snapshot.value as Map;
    Iterable<int> ks = mapa.keys;
    Productos p;
    Iterable<dynamic> mapaProd = datos.values;
    List<Productos> listaProductos = mapToListProducto(mapaProd);

    for (final id in ks) {
      for (Productos prod in listaProductos) {
        if (prod.id == id) {
          p = prod;
          resultado += '${p.nombre} x${mapa[id]}.......... ${p.precio}€/und.\n';
        }
      }
    }

    /*for (int i = 0; i < mapa.length; i++) {
      Productos p = await op.getProductoById(
          mapa.keys.firstWhere((j) => mapa[j] == mapa[i], orElse: () => 0));
      resultado += p.nombre +
          ' x' +
          mapa[p.id].toString() +
          '.......... ' +
          p.precio.toString() +
          '€/und.\n';
    }*/

    return resultado;
  }

  static Future<List<Object>> getDatosUsuario(String email) async {
    List<Object> lista = <Object>[];

    Usuarios user = await OperacionesUsuario.getUser(email);
    List<Pedidos> pedidos = await OperacionesPedido.getPedidosFromUser(user.id);

    lista.add(user);
    lista.add(pedidos);

    return lista;
  }

  static Future<int> generateIdUser() async {
    List<Usuarios> users = await OperacionesUsuario.getPersonas();
    return users.length;
  }

  static Future<int> generateIdProducto() async {
    List<Productos> p = await OperacionesProducto.getProductos();
    return p.length + 1;
  }

  static List<Productos> mapToListProducto(Iterable<dynamic> iterable) {
    List<Productos> productos = <Productos>[];

    for (final element in iterable) {
      Productos p = Productos(
          id: element['id'],
          nombre: element['nombre'],
          descripcion: element['descripcion'],
          imagen: element['imagen'],
          precio: element['precio']);

      productos.add(p);
    }

    return productos;
  }
}
