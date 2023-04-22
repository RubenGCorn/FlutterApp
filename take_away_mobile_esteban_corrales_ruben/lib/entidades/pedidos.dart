class Pedidos {
  int id;
  int? idUsuario;
  String listaProductos;

  Pedidos(
      {required this.id,
      required this.idUsuario,
      required this.listaProductos});

  Map<String, dynamic> toMap() {
    return {"id": id, "idUsuario": idUsuario, 'listaProductos': listaProductos};
  }
}
