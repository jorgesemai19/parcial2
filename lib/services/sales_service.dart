import 'package:parcial2/models/sale.dart';

class SalesService {
  static final SalesService _instance = SalesService._internal();

  factory SalesService() {
    return _instance;
  }

  SalesService._internal();

  final List<Sale> _sales = []; // Lista para almacenar las ventas

  // Método para agregar una venta
  void addSale(Sale sale) {
    _sales.add(sale);
  }

  // Método para obtener todas las ventas
  List<Sale> getAllSales() {
    return _sales;
  }
}
