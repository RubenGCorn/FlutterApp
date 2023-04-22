import 'package:flutter/material.dart';

import '../controladores/OperacionesPedido.dart';
import '../controladores/OperacionesUsuario.dart';
import '../controladores/servicios.dart';
import '../entidades/argumento.dart';
import '../entidades/pedidos.dart';
import '../entidades/usuarios.dart';

class VistaPago extends StatefulWidget {
  @override
  _VistaPago createState() => _VistaPago();
}

class _VistaPago extends State<VistaPago> {
  @override
  Widget build(BuildContext context) {
    final List<Argumento> task =
        ModalRoute.of(context)!.settings.arguments as List<Argumento>;

    int _selectedIndex = 0;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: 'Cancelar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Aceptar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: ((int i) async {
          switch (i) {
            case 0:
              Navigator.pop(context, false);
              break;
            case 1:
              Usuarios user = await OperacionesUsuario.getUser(task[1].valor);
              Pedidos p = Pedidos(
                  id: await Servicios.asignarIdPedido(),
                  idUsuario: user.id,
                  listaProductos:
                      await Servicios.detallesPedido(task[0].valor));
              OperacionesPedido.insertPedido(p);
              Navigator.pop(context, true);
              break;
          }
        }),
      ),
      body: FutureBuilder(
        future: Servicios.getDatosPedido(task[0].valor),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _DetallesPedido(snapshot.data);
          }
        },
      ),
    );
  }
}

class _DetallesPedido extends StatelessWidget {
  final List<Object> datos;
  _DetallesPedido(this.datos);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Pedido: #' + datos[0].toString(),
            style: TextStyle(fontSize: 60),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            datos[1].toString(),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Total:..........' + datos[2].toString() + '€',
            style: TextStyle(fontSize: 50),
          ),
        ),
      ],
    );
  }
}
