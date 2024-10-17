import 'package:flutter/material.dart';
import 'package:parcial2/models/sale.dart';

class SaleDetailScreen extends StatelessWidget {
  final Sale sale;

  const SaleDetailScreen({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${sale.nombre} ${sale.apellido}', style: const TextStyle(fontSize: 18)),
            Text('Cédula: ${sale.cedula}', style: const TextStyle(fontSize: 18)),
            Text('Fecha: ${sale.fecha.toString().split(' ')[0]}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Productos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Listado de productos comprados
            Expanded(
              child: ListView.builder(
                itemCount: sale.productos.length,
                itemBuilder: (context, index) {
                  final product = sale.productos.keys.toList()[index];  // Obtener el producto
                  final quantity = sale.productos[product]!;  // Obtener la cantidad

                  return ListTile(
                    title: Text(product.nombre),  // Mostrar el nombre del producto
                    subtitle: Text('Cantidad: $quantity, Precio: \$${product.precioVenta.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Total de la venta: \$${sale.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
