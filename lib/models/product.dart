class Product {
  int idProducto;
  String nombre;
  int? idCategoria; // Relación con Category
  double precioVenta;
  String? imagenLocal; // Nueva propiedad para la imagen
  final int cantidad;//cantidad disponible del producto

  Product({
    required this.idProducto,
    required this.nombre,
    required this.idCategoria,
    required this.precioVenta,
    this.imagenLocal, // Es opcional, ya que algunos productos podrían no tener imagen
    this.cantidad=0,
  });
}
