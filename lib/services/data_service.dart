import 'package:parcial2/models/category.dart';
import 'package:parcial2/models/product.dart';
import 'package:flutter/material.dart';

class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() => _instance;

  DataService._internal() {
    // Precargar productos cuando se inicializa el servicio
    products = [
      Product(idProducto: 1, nombre: 'Laptop', idCategoria: 1, precioVenta: 1200.0),
      Product(idProducto: 2, nombre: 'Smartphone', idCategoria: 1, precioVenta: 800.0),
      Product(idProducto: 3, nombre: 'Camiseta', idCategoria: 2, precioVenta: 20.0),
      Product(idProducto: 4, nombre: 'Pantalones', idCategoria: 2, precioVenta: 35.0),
    ];
  }

  // Lista de categorías
  List<Category> categories = [
    Category(idCategoria: 1, nombre: 'Electrónica', icono: Icons.computer),
    Category(idCategoria: 2, nombre: 'Ropa', icono: Icons.checkroom),
  ];

  // Getter para acceder a las categorías
  List<Category> get categorias => categories;

  // Lista de productos
  List<Product> products = [];

  // Métodos CRUD para categorías
  void addCategory(Category category) {
    categories.add(category);
  }

  void updateCategory(int id, String newName) {
    var category = categories.firstWhere((cat) => cat.idCategoria == id);
    category.nombre = newName;
  }

  void deleteCategory(int id) {
    categories.removeWhere((cat) => cat.idCategoria == id);
  }

  // Método para obtener el ícono de una categoría
  IconData getIconForCategory(int? idCategoria) {
    if (idCategoria != null) {
      final categoria = categories.firstWhere(
        (categoria) => categoria.idCategoria == idCategoria,
        orElse: () => Category(idCategoria: 0, nombre: 'Genérico', icono: Icons.category),
      );
      return categoria.icono;
    } else {
      return Icons.category; // Ícono genérico si no se especifica categoría
    }
  }

  // Métodos CRUD para productos
  void addProduct(Product product) {
    products.add(product);
  }

  void updateProduct(int id, String newName, double newPrice, int newCantidad) {
    var product = products.firstWhere((prod) => prod.idProducto == id);
    product.nombre = newName;
    product.precioVenta = newPrice;
    product.cantidad = newCantidad;
  }

  void deleteProduct(int id) {
    products.removeWhere((prod) => prod.idProducto == id);
  }

  // Método para obtener la categoría de un producto
  Category? getCategoryForProduct(Product product) {
    return categories.firstWhere(
      (category) => category.idCategoria == product.idCategoria,
      orElse: () => Category(idCategoria: 0, nombre: 'Sin categoría', icono: Icons.category),
    );
  }
}
