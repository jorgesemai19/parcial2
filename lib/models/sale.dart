import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcial2/models/product.dart';

class Sale {
  final String id;
  final String cedula;
  final String nombre;
  final String apellido;
  final DateTime fecha;
  final Map<Product, int> productos;
  final double total;
  final String deliveryOption; // Opción de entrega
  final LatLng? deliveryLocation; // Ubicación de entrega (si es delivery)

  Sale({
    required this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.fecha,
    required this.productos,
    required this.total,
    required this.deliveryOption,
    this.deliveryLocation, // Opcional
  });
}
