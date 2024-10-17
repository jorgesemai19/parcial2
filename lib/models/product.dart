class Product {
  int idProducto;
  String nombre;
  int idCategoria; // Relación con Category
  double precioVenta;

  Product({
    required this.idProducto,
    required this.nombre,
    required this.idCategoria,
    required this.precioVenta,
  });
}