import 'package:flutter/material.dart';
import 'package:parcial2/screens/category_screen.dart';
import 'package:parcial2/screens/product_screen.dart';
import 'package:parcial2/screens/sales_screen.dart'; // Nueva pantalla de ventas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrito de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SalesScreen(), // Cambiar pantalla principal a la de ventas
      routes: {
        '/categories': (context) => CategoryScreen(), // Ruta para CRUD de categorías
        '/products': (context) => const ProductScreen(), // Ruta para CRUD de productos
      },
    );
  }
}
