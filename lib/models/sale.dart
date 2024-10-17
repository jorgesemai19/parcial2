import 'product.dart';

class Sale {
  final String id;  // ID único de la venta
  final String cedula;
  final String nombre;
  final String apellido;
  final DateTime fecha;
  final Map<Product, int> productos; // Productos y sus cantidades
  final double total;

  Sale({
    required this.id,    // Asegurarse de pasar el ID
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.fecha,
    required this.productos,
    required this.total,
  });
}
