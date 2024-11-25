import 'package:flutter/material.dart';
import 'package:parcial2/models/product.dart';
import 'package:parcial2/services/data_service.dart';
import 'package:parcial2/screens/cart_screen.dart';
import 'package:parcial2/screens/sales_query_screen.dart'; // Importa la pantalla de consulta de ventas

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _dataService = DataService();
  List<Product> _filteredProducts = [];
  final List<Product> _cart = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredProducts = _dataService.products; // Inicialmente muestra todos los productos
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _filteredProducts = _dataService.products; // Actualiza la lista de productos
    });
  }

  void _updateSearch(String value) {
    setState(() {
      _searchQuery = value;
      _filteredProducts = _dataService.products.where((product) {
        return product.nombre.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  // Función para limpiar el carrito
  void _clearCart() {
    setState(() {
      _cart.clear();  // Vaciar el carrito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El carrito ha sido vaciado.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas - Carrito de Compras'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        _cart.length.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Navegar a la pantalla del carrito
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: _cart),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _updateSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ListTile(
                    leading: Icon(_dataService.getIconForCategory(product.idCategoria), color: Colors.grey),
                    title: Text(product.nombre),
                    subtitle: Text(
                        'Precio: \$${product.precioVenta.toStringAsFixed(2)}\t\t\tCantidad: ${product.cantidad.toStringAsFixed(0)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        _addToCart(product);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/categories');
                    _refreshProducts();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('CRUD de Categorías'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/products');
                    _refreshProducts();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('CRUD de Productos'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Botón para limpiar el carrito
            Center(
              child: ElevatedButton(
                onPressed: _clearCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,  // Fondo rojo para indicar que es acción de limpieza
                  foregroundColor: Colors.white,  // Texto blanco
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Limpiar Carrito'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navegar al módulo de consulta de ventas
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesQueryScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Fondo verde
                  foregroundColor: Colors.white,  // Texto blanco
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Consultar Ventas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
