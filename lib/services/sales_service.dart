import 'package:parcial2/models/sale.dart';
import 'package:parcial2/models/product.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos

class SalesService {
  static final SalesService _instance = SalesService._internal();

  factory SalesService() {
    return _instance;
  }

  SalesService._internal() {
    // Precargar ventas al inicializar el servicio
    _sales.addAll([
      Sale(
        id: _uuid.v4(),
        cedula: '12345678',
        nombre: 'Carlos',
        apellido: 'Pérez',
        fecha: DateTime(2024, 10, 15), // Fecha de la venta
        productos: {
          Product(idProducto: 1, nombre: 'Laptop', idCategoria: 1, precioVenta: 1200.0): 1,
          Product(idProducto: 2, nombre: 'Smartphone', idCategoria: 1, precioVenta: 800.0): 1,
        },
        total: 2000.0,
      ),
      Sale(
        id: _uuid.v4(),
        cedula: '87654321',
        nombre: 'Ana',
        apellido: 'López',
        fecha: DateTime(2024, 10, 16), // Fecha de la venta
        productos: {
          Product(idProducto: 3, nombre: 'Camiseta', idCategoria: 2, precioVenta: 20.0): 2,
          Product(idProducto: 4, nombre: 'Pantalones', idCategoria: 2, precioVenta: 35.0): 1,
        },
        total: 75.0,
      ),
    ]);
  }

  final List<Sale> _sales = []; // Lista para almacenar las ventas
  final _uuid = Uuid(); // Para generar IDs únicos

  // Método para agregar una venta
  void addSale(Sale sale) {
    _sales.add(sale);
  }

  // Método para obtener todas las ventas
  List<Sale> getAllSales() {
    return _sales;
  }
}
