import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/Vistas/main.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/historialpedidos.dart';

import '../controladores/servicios.dart';
import '../entidades/usuarios.dart';

class PerfilCliente extends StatefulWidget {
  @override
  _PerfilCliente createState() => _PerfilCliente();
}

class _PerfilCliente extends State<PerfilCliente> {
  @override
  Widget build(BuildContext context) {
    var argumento = ModalRoute.of(context)!.settings.arguments.toString();
    int _selectedIndex = 0;
    return Scaffold(
        appBar: AppBar(title: const Text('Mi Perfil'), actions: []),
        body: FutureBuilder(
          future: Servicios.getDatosUsuario(argumento),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _DetallesUsuario(snapshot.data);
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.login_outlined), label: 'Cerrar Sesion'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book), label: 'Mis Pedidos'),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) async {
            switch (index) {
              case 0:
                var navigationResult = await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: '',
                            )));
                break;
              case 1:
                var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistorialPedidos(),
                        settings: RouteSettings(
                            arguments: ModalRoute.of(context)!
                                .settings
                                .arguments
                                .toString())));
                break;
            }
          },
        ));
  }
}

class _DetallesUsuario extends StatelessWidget {
  final List<Object> datos;
  _DetallesUsuario(this.datos);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Hola, ' + (datos[0] as Usuarios).nombre,
            style: TextStyle(fontSize: 40),
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Hola, ' + (datos[0] as Usuarios).email,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
