class Productos {
  int id;
  String nombre;
  String descripcion;
  String imagen;
  double precio;

  Productos(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.imagen,
      required this.precio});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      'descripcion': descripcion,
      'imagen': imagen,
      'precio': precio
    };
  }
}
