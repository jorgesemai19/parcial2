import 'package:flutter/material.dart';
import 'package:parcial2/models/product.dart';
import 'package:parcial2/screens/endsales_screen.dart'; // Importar la pantalla de finalización de compra
import 'package:parcial2/screens/sales_screen.dart'; // Importar la pantalla de ventas

class CartScreen extends StatefulWidget {
  final List<Product> cart;

  const CartScreen({Key? key, required this.cart}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<Product, int> _productQuantities = {};
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  void _initializeCart() {
    // Inicializamos las cantidades del carrito
    for (var product in widget.cart) {
      if (_productQuantities.containsKey(product)) {
        _productQuantities[product] = _productQuantities[product]! + 1;
      } else {
        _productQuantities[product] = 1;
      }
    }
    _calculateTotal();
  }

  void _calculateTotal() {
    double total = 0.0;
    _productQuantities.forEach((product, quantity) {
      total += product.precioVenta * quantity;
    });
    setState(() {
      _total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Navegar a la pantalla de ventas
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
            Expanded(
              child: ListView.builder(
                itemCount: _productQuantities.length,
                itemBuilder: (context, index) {
                  final product = _productQuantities.keys.toList()[index];
                  final quantity = _productQuantities[product]!;
                  return ListTile(
                    title: Text(product.nombre),
                    subtitle: Text('Cantidad: $quantity x \$${product.precioVenta.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: \$${_total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de finalización de compra
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      total: _total,
                      cart: _productQuantities,
                    ),
                  ),
                );
              },
              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}
