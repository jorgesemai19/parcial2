import 'package:parcial2/models/category.dart';
import 'package:parcial2/models/product.dart';

class DataService {
  static final DataService _instance = DataService._internal();

  factory DataService() => _instance;

  DataService._internal();

  List<Category> categories = [
    Category(idCategoria: 1, nombre: 'Electrónica'),
    Category(idCategoria: 2, nombre: 'Ropa'),
  ];

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

  // Métodos CRUD para productos
  void addProduct(Product product) {
    products.add(product);
  }

  void updateProduct(int id, String newName, double newPrice) {
    var product = products.firstWhere((prod) => prod.idProducto == id);
    product.nombre = newName;
    product.precioVenta = newPrice;
  }

  void deleteProduct(int id) {
    products.removeWhere((prod) => prod.idProducto == id);
  }
}
