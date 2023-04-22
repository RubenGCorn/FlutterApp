import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/Vistas/adminMainPage.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/Register.dart';
import 'package:take_away_mobile_esteban_corrales_ruben/vistas/UserMainPage.dart';
import 'package:firebase_core/firebase_core.dart';

import '../controladores/OperacionesProducto.dart';
import '../controladores/OperacionesUsuario.dart';
import '../controladores/operacionesPedido.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<FirebaseApp> fbApp = Firebase.initializeApp();
  OperacionesUsuario.openDB();
  OperacionesProducto.openDB();
  OperacionesPedido.openDB();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TAKE AWAY MOBILE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController textoValidacion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  '¡Bienvenido!',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 255, 255, 255)),
                )),
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
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if (await OperacionesUsuario.existsUser(
                        emailController.text)) {
                      if ((await OperacionesUsuario.getUser(
                                  emailController.text))
                              .idRol ==
                          2) {
                        var navigationResult = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => AdminMainPage(),
                                settings: RouteSettings(
                                    arguments: emailController.text)));
                      } else {
                        var navigationResult = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => UserMainPage(),
                                settings: RouteSettings(
                                    arguments: emailController.text)));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('no valido'),
                      ));
                    }
                  },
                )),
            Container(
              child: Column(children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: '¿Aun no tienes una cuenta?',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          var navigationResult = await Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Register()));
                        }),
                ])),
              ]),
            ),
          ],
        ),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
