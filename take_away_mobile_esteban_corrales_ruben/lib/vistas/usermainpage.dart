import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/controladores/servicios.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/perfilcliente.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/vistapago.dart';
import 'package:firebase_core/firebase_core.dart';

import '../controladores/OperacionesProducto.dart';
import '../entidades/argumento.dart';
import '../entidades/productos.dart';

var carritoExterno = new Map<int, int>();

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPage createState() => _UserMainPage();
}

class _UserMainPage extends State<UserMainPage> {
  int _selectedIndex = 0;

  List<Argumento> listaArgumentos = <Argumento>[];

  @override
  Widget build(BuildContext context) {
    var carrito = new Map<int, int>();

    final dbRef = FirebaseDatabase.instance.ref().child("productos");

    return Scaffold(
        /* floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text(carritoNumber.toString()),
        ),*/

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(00, 00, 00, 00),
              icon: Icon(Icons.add_card_rounded),
              label: 'Completar Pedido',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.brush),
              label: 'Vaciar Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login_outlined),
              label: 'Log Out',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) async {
            switch (index) {
              case 0:
                carrito = carritoExterno;
                print(carrito.toString());
                print(carritoExterno.toString());
                listaArgumentos.add(Argumento('carrito', carrito));
                listaArgumentos.add(Argumento(
                    'user', ModalRoute.of(context)!.settings.arguments));
                if (carrito.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Carrito Vacio'),
                  ));
                } else {
                  var navigationResult = await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => VistaPago(),
                          settings: RouteSettings(arguments: listaArgumentos)));
                }

                break;
              case 1:
                carritoExterno.clear();
                break;
              case 2:
                Navigator.pop(context, true);
                break;
            }
          },
        ),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                listaArgumentos = <Argumento>[];
                listaArgumentos.add(Argumento('carrito', carrito));
                listaArgumentos.add(Argumento(
                    'user', ModalRoute.of(context)!.settings.arguments));
                var navigationResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PerfilCliente(),
                        settings: RouteSettings(
                            arguments:
                                ModalRoute.of(context)!.settings.arguments)));
              },
              icon: const Icon(Icons.account_circle_outlined),
              tooltip: ModalRoute.of(context)!.settings.arguments.toString(),
            ),
          ],
          title: const Text('Pagina Principal'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://mejorconsalud.as.com/wp-content/uploads/2015/12/comida-chatarra-mala-salud.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final productos = (snapshot.data!.snapshot.value as Map).values;
                for (final element in productos) {
                  print(element);
                }
                return _ListaProductos(productos);
              }
            },
          ),
        ));
  }
}

class _ListaProductos extends StatelessWidget {
  List<Productos> productos = <Productos>[];
  Iterable<dynamic> mapas = {};
  _ListaProductos(this.mapas);

  @override
  Widget build(BuildContext context) {
    productos = Servicios.mapToListProducto(mapas);
    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _PopupDetalle(context, productos[index], productos, index));
          },
          leading: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 64,
                maxHeight: 64,
              ),
              child: Image.network(productos[index].imagen)),
          title: Text(productos[index].nombre,
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 51, 255, 255))),
          subtitle: Text(productos[index].descripcion,
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 51, 255, 255))),
          trailing: Text(productos[index].precio.toString() + '€',
              style: TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 51, 255, 255))),
        );
      },
    );
  }
}

Widget _PopupDetalle(
    BuildContext context, Productos p, List<Productos> productos, int index) {
  return AlertDialog(
    title: const Text('Atencion:'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(p.nombre),
        Text(p.descripcion),
        Text(p.precio.toString() + '€'),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          if (carritoExterno[p.id] == null) {
            carritoExterno.putIfAbsent(p.id, () => 1);
          } else {
            carritoExterno[productos[index].id] =
                (carritoExterno[productos[index].id]! + 1);
          }

          Navigator.of(context).pop();
        },
        child: const Text('Añadir al carrito'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cerrar'),
      ),
    ],
  );
}
