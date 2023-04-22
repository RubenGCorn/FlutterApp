class Usuarios {
  int id;
  int? idRol;
  String nombre;
  String email;
  String pass;

  Usuarios(
      {required this.id,
      required this.idRol,
      required this.nombre,
      required this.email,
      required this.pass});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "idRol": idRol,
      "nombre": nombre,
      'email': email,
      'pass': pass
    };
  }
}
