import 'package:flutter/material.dart';
import 'package:parcial2/models/product.dart';
import 'package:parcial2/models/sale.dart';
import 'package:parcial2/services/sales_service.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos
import 'package:parcial2/screens/sale_detail_screen.dart'; // Para mostrar el detalle de la venta

class CheckoutScreen extends StatefulWidget {
  final double total;
  final Map<Product, int> cart;

  const CheckoutScreen({Key? key, required this.total, required this.cart}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();

  final _salesService = SalesService(); // Servicio de ventas
  final _uuid = Uuid(); // Para generar IDs únicos

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  void _finalizePurchase() {
    final cedula = _cedulaController.text;
    final nombre = _nombreController.text;
    final apellido = _apellidoController.text;

    if (cedula.isNotEmpty && nombre.isNotEmpty && apellido.isNotEmpty) {
      // Generar un ID único para la venta
      final saleId = _uuid.v4();

      // Crear la venta
      final sale = Sale(
        id: saleId,
        cedula: cedula,
        nombre: nombre,
        apellido: apellido,
        fecha: DateTime.now(),
        productos: Map.from(widget.cart),
        total: widget.total,
      );

      // Registrar la venta
      _salesService.addSale(sale);

      // Limpiar el carrito
      widget.cart.clear();

      // Redirigir al detalle de la venta
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SaleDetailScreen(sale: sale),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cedulaController,
              decoration: const InputDecoration(labelText: 'Cédula'),
            ),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 20),
            Text(
              'Total a pagar: \$${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _finalizePurchase,
              child: const Text('Confirmar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}
