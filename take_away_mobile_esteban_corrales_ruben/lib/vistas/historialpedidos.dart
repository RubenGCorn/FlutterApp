import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controladores/OperacionesPedido.dart';
import '../controladores/OperacionesUsuario.dart';
import '../entidades/pedidos.dart';
import '../entidades/usuarios.dart';

class HistorialPedidos extends StatefulWidget {
  _HistorialPedidos createState() => _HistorialPedidos();
}

class _HistorialPedidos extends State<HistorialPedidos> {
  String titulo = "";
  @override
  Widget build(BuildContext context) {
    var mail = ModalRoute.of(context)!.settings.arguments.toString();
    Future<Usuarios> user = OperacionesUsuario.getUser(mail);
    Future<List<Pedidos>> pedidos =
        OperacionesPedido.pedidosFromFutureUser(user);
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Pedidos'), actions: []),
      body: FutureBuilder(
        future: pedidos,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _ListaPedidos(snapshot.data);
          }
        },
      ),
    );
  }
}

class _ListaPedidos extends StatelessWidget {
  final List<Pedidos> pedidos;
  _ListaPedidos(this.pedidos);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Text(pedidos[index].id.toString()),
          title: Text(pedidos[index].listaProductos),
          //trailing: Text(pedidos[index].getTotal().toString()),
        );
      },
    );
  }
}
