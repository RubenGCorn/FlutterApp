import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/controladores/servicios.dart';
import 'package:firebase_core/firebase_core.dart';

import '../controladores/OperacionesProducto.dart';
import '../entidades/productos.dart';

class NuevoProducto extends StatefulWidget {
  @override
  _NuevoProducto createState() => _NuevoProducto();
}

class _NuevoProducto extends State<NuevoProducto> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController precioController = TextEditingController();

  final Future<FirebaseApp> fbApp = Firebase.initializeApp();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Añadir un Nuevo Producto'), actions: []),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Nuevo Producto',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(),
                  labelText: 'Descripcion',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(),
                  labelText: 'Imagen',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: precioController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(),
                  labelText: 'Precio',
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.block), label: 'Cancelar'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Aceptar'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int i) async {
          switch (i) {
            case 0:
              Navigator.pop(context, true);
              break;
            case 1:
              if (nameController.text == '' ||
                  descriptionController.text == '' ||
                  imageController.text == '' ||
                  precioController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Datos no validos'),
                ));
              } else {
                Productos p = Productos(
                    id: await Servicios.generateIdProducto(),
                    nombre: nameController.text,
                    descripcion: descriptionController.text,
                    imagen: imageController.text,
                    precio: double.parse(precioController.text));

                DatabaseReference dbRef =
                    FirebaseDatabase.instance.ref('productos');
                DatabaseReference newProducto = dbRef.push();
                newProducto.set(p.toMap());

                //OperacionesProducto.insertProducto(p);
                break;
              }
          }
        },
      ),
    );
  }
}
