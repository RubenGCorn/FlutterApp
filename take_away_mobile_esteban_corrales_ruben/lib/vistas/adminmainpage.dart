import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/historialpedidos.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/nuevoproducto.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/registeradmin.dart';

import '../controladores/OperacionesPedido.dart';
import '../entidades/pedidos.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPage createState() => _AdminMainPage();
}

//var navigationResult = await Navigator.push(context,
//new MaterialPageRoute(builder: (context) => RegisterAdmin()));

class _AdminMainPage extends State<AdminMainPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos Pendientes: '), actions: []),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.login_outlined,
              ),
              label: 'Salir',
              tooltip: 'Salir'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: 'Añadir nuevo Producto',
              tooltip: 'Añadir nuevo Producto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Registrar Nuevo Empleado',
              tooltip: 'Registrar Nuevo Empleado'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) async {
          switch (index) {
            case 0:
              Navigator.pop(context, true);
              break;
            case 1:
              var navigationResult = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => NuevoProducto(),
                      settings: RouteSettings(arguments: '')));
              break;
            case 2:
              var navigationResult = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => RegisterAdmin(),
                      settings: RouteSettings(arguments: '')));
              break;
          }
        },
      ),
      body: FutureBuilder(
        future: OperacionesPedido.getPedidos(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _PedidosPendientes(snapshot.data);
          }
        },
      ),
    );
  }
}

class _PedidosPendientes extends StatelessWidget {
  List<Pedidos> pedidos = <Pedidos>[];
  _PedidosPendientes(this.pedidos);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            showDialog(
                    context: context,
                    builder: (BuildContext context) => _PopupCompletar(context))
                .then((value) {
              if (value) {
                OperacionesPedido.deletePedido(pedidos[index]);
              }
            });
          },
          leading: Text(pedidos[index].id.toString()),
          title: Text(pedidos[index].listaProductos.toString()),
          trailing: const Icon(Icons.arrow_forward_ios_sharp),
        );
      },
    );
  }
}

Widget _PopupCompletar(BuildContext context) {
  bool aceptado = true;
  return AlertDialog(
    title: const Text('¿Completar pedido?'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('¿Cancelar pedido?'),
      ],
    ),
    actions: <Widget>[
      TextButton(
          onPressed: () => Navigator.pop(context, !aceptado),
          child: Text('Cancelar')),
      TextButton(
          onPressed: () => Navigator.pop(context, aceptado),
          child: Text('Aceptar'))
    ],
  );
}
