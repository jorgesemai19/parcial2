import 'package:flutter/material.dart';
import 'package:parcial2/models/product.dart';
import 'package:parcial2/models/sale.dart';
import 'package:parcial2/services/sales_service.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos
import 'package:parcial2/screens/sale_detail_screen.dart'; // Para mostrar el detalle de la venta
import 'package:parcial2/services/data_service.dart'; // Para actualizar inventario
import 'package:parcial2/screens/sales_screen.dart'; // Para navegar a SalesScreen

class CheckoutScreen extends StatefulWidget {
  final double total;
  final Map<Product, int> cart;

  const CheckoutScreen({Key? key, required this.total, required this.cart})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}
class _CheckoutScreenState extends State<CheckoutScreen> {
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();

  final _salesService = SalesService();
  final _uuid = Uuid();
  final _dataService = DataService();

  String _deliveryOption = 'pickup'; // Valor predeterminado

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
      final saleId = _uuid.v4();

      final sale = Sale(
        id: saleId,
        cedula: cedula,
        nombre: nombre,
        apellido: apellido,
        fecha: DateTime.now(),
        productos: Map.from(widget.cart),
        total: widget.total,
        deliveryOption: _deliveryOption, // Incluye la opción seleccionada
      );

      _salesService.addSale(sale);

      widget.cart.forEach((product, quantity) {
        final Product? productToUpdate = _dataService.products
            .firstWhere((p) => p.idProducto == product.idProducto);

        if (productToUpdate != null) {
          productToUpdate.cantidad -= quantity;
          if (productToUpdate.cantidad < 0) {
            productToUpdate.cantidad = 0;
          }
        } else {
          debugPrint(
              'Producto con ID ${product.idProducto} no encontrado en el inventario.');
        }
      });
      widget.cart.clear();

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
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SalesScreen(),
              ),
            );
          },
        ),
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
            DropdownButton<String>(
              value: _deliveryOption,
              onChanged: (value) {
                setState(() {
                  _deliveryOption = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'pickup',
                  child: Text('Pickup'),
                ),
                DropdownMenuItem(
                  value: 'delivery',
                  child: Text('Delivery'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Total a pagar: \$${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
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
