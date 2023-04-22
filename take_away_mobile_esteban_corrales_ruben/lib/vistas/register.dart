import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/controladores/servicios.dart';

import '../controladores/OperacionesUsuario.dart';
import '../entidades/usuarios.dart';

//Pagina de Registro
class Register extends StatefulWidget {
  @override
  _Page2 createState() => _Page2();
}

class _Page2 extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();

  TextEditingController textoValidacion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.login_outlined),
          onPressed: (() {
            Navigator.pop(context, true);
          }),
        ),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://mejorconsalud.as.com/wp-content/uploads/2015/12/comida-chatarra-mala-salud.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Formulario de Registro',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255)),
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
                    controller: emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: password2Controller,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      border: OutlineInputBorder(),
                      labelText: 'Repita la Contraseña',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Registrarse'),
                      onPressed: () async {
                        if (passwordController.text !=
                            password2Controller.text) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Las contraseñas no cohinciden'),
                          ));
                        } else {
                          if (!(await OperacionesUsuario.existsUser(
                              emailController.text))) {
                            var newUser = Usuarios(
                                email: emailController.text,
                                id: await Servicios.generateIdUser(),
                                idRol: 1,
                                nombre: nameController.text,
                                pass: passwordController.text);

                            OperacionesUsuario.insertUser(newUser);
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Usuario Existente'),
                            ));
                          }
                        }
                      },
                    )),
              ]),
        )));
  }
}
