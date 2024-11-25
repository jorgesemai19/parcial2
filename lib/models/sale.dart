import 'product.dart';

class Sale {
  final String id;
  final String cedula;
  final String nombre;
  final String apellido;
  final DateTime fecha;
  final Map<Product, int> productos;
  final double total;
  final String deliveryOption; // Nueva opción: "delivery" o "pickup"

  Sale({
    required this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.fecha,
    required this.productos,
    required this.total,
    required this.deliveryOption, // Requerido
  });
}
