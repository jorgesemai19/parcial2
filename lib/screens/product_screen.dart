import 'package:flutter/material.dart';
import 'package:parcial2/models/product.dart';
import 'package:parcial2/models/category.dart';
import 'package:parcial2/services/data_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  Category? _selectedCategory;
  final _dataService = DataService();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = true; // Mostrar el formulario para agregar producto
                  _clearForm();
                });
              },
              child: const Text('Agregar Producto'),
            ),
            const SizedBox(height: 20),
            if (_isEditing) _buildProductForm(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _dataService.products.length,
                itemBuilder: (context, index) {
                  var product = _dataService.products[index];
                  var category = _dataService.getCategoryForProduct(product);
                  
                  
                  return ListTile(
                    title: Text('${product.idProducto}:  ${product.nombre}'),
                    subtitle: Text(
                      'Precio: \$${product.precioVenta.toStringAsFixed(2)}\n'
                      'Categoría: ${category != null ? category.nombre : "No asignada"}', // Muestra "No asignada" si la categoría es null
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteProduct(product.idProducto);
                      },
                    ),
                    onTap: () {
                      _editProduct(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Column(
      children: [
        DropdownButton<Category>(
          hint: const Text('Seleccione una categoría'),
          value: _selectedCategory,
          onChanged: (Category? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
          items: _dataService.categories.map((Category category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(category.nombre),
            );
          }).toList(),
        ),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre del producto'),
        ),
        TextField(
          controller: _priceController,
          decoration: const InputDecoration(labelText: 'Precio del producto'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: _addProduct,
          child: const Text('Guardar Producto'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = false; // Ocultar el formulario
              _clearForm();
            });
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  void _addProduct() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    setState(() {
      final newProduct = Product(
        idProducto: _dataService.products.length + 1,
        nombre: _nameController.text,
        idCategoria: _selectedCategory!.idCategoria,
        precioVenta: double.tryParse(_priceController.text) ?? 0.0,
      );
      _dataService.addProduct(newProduct);
      _isEditing = false;
      _clearForm();
    });
  }

  void _deleteProduct(int id) {
    setState(() {
      _dataService.deleteProduct(id);
    });
  }

  void _editProduct(Product product) {
    setState(() {
      _nameController.text = product.nombre;
      _priceController.text = product.precioVenta.toString();
      _selectedCategory = _dataService.categories.firstWhere((cat) => cat.idCategoria == product.idCategoria);
      _deleteProduct(product.idProducto);
      _isEditing = true;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _selectedCategory = null;
  }
}
