import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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

  String? _imagePath; // Ruta de la imagen seleccionada

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        // Guardar la imagen seleccionada localmente
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String localPath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final File localImage = File(localPath);
        await localImage.writeAsBytes(await pickedImage.readAsBytes());

        setState(() {
          _imagePath = localPath;
        });
      }
    } catch (e) {
      print('Error al seleccionar la imagen: $e');
    }
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
                    leading: product.imagenLocal != null
                        ? Image.file(File(product.imagenLocal!))
                        : const Icon(Icons.image, size: 50),
                    title: Text('${product.idProducto}:  ${product.nombre}'),
                    subtitle: Text(
                      'Precio: \$${product.precioVenta.toStringAsFixed(2)}\n'
                      'Categoría: ${category != null ? category.nombre : "No asignada"}',
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
        const SizedBox(height: 10),
        if (_imagePath != null)
          Image.file(File(_imagePath!), height: 100, width: 100, fit: BoxFit.cover),
        ElevatedButton(
          onPressed: _selectImage,
          child: const Text('Seleccionar Imagen'),
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
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null ||
        _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos, incluida la imagen')),
      );
      return;
    }

    setState(() {
      final newProduct = Product(
        idProducto: _dataService.products.length + 1,
        nombre: _nameController.text,
        idCategoria: _selectedCategory!.idCategoria,
        precioVenta: double.tryParse(_priceController.text) ?? 0.0,
        imagenLocal: _imagePath, // Agrega la ruta de la imagen
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
      _imagePath = product.imagenLocal; // Carga la imagen existente
      _deleteProduct(product.idProducto);
      _isEditing = true;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _priceController.clear();
    _selectedCategory = null;
    _imagePath = null;
  }
}
