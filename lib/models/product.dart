class Product {
  int idProducto;
  String nombre;
  int? idCategoria; // Relación con Category
  double precioVenta;
  String? imagenUrl; // Nueva propiedad para la imagen
  int cantidad;//cantidad disponible del producto

  Product({
    required this.idProducto,
    required this.nombre,
    required this.idCategoria,
    required this.precioVenta,
    this.imagenUrl, // Es opcional, ya que algunos productos podrían no tener imagen
    this.cantidad,
  });
}
