import 'package:flutter/material.dart';
import 'package:parcial2/models/category.dart';
import 'package:parcial2/services/data_service.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _nameController = TextEditingController();
  final _dataService = DataService();
  IconData? _selectedIcon;
  bool _isEditing = false; // Estado para controlar el modo de edición
  int? _editingCategoryId; // ID de la categoría que se está editando

  void _selectIcon(BuildContext context) async {
    IconData? icon = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un ícono'),
          content: Container(
            height: 300,
            width: double.maxFinite,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                IconButton(
                  icon: const Icon(Icons.computer), // Electrónica
                  onPressed: () => Navigator.of(context).pop(Icons.computer),
                ),
                IconButton(
                  icon: const Icon(Icons.sports_soccer), // Deportes
                  onPressed: () => Navigator.of(context).pop(Icons.sports_soccer),
                ),
                IconButton(
                  icon: const Icon(Icons.kitchen), // Electrodomésticos
                  onPressed: () => Navigator.of(context).pop(Icons.kitchen),
                ),
                IconButton(
                  icon: const Icon(Icons.school), // Papelería
                  onPressed: () => Navigator.of(context).pop(Icons.school),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_android), // Teléfonos móviles
                  onPressed: () => Navigator.of(context).pop(Icons.phone_android),
                ),
                IconButton(
                  icon: const Icon(Icons.watch), // Relojes
                  onPressed: () => Navigator.of(context).pop(Icons.watch),
                ),
                IconButton(
                  icon: const Icon(Icons.chair), // Muebles
                  onPressed: () => Navigator.of(context).pop(Icons.chair),
                ),
                IconButton(
                  icon: const Icon(Icons.book), // Libros
                  onPressed: () => Navigator.of(context).pop(Icons.book),
                ),
                IconButton(
                  icon: const Icon(Icons.directions_car), // Autos
                  onPressed: () => Navigator.of(context).pop(Icons.directions_car),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag), // Ropa
                  onPressed: () => Navigator.of(context).pop(Icons.shopping_bag),
                ),
                IconButton(
                  icon: const Icon(Icons.pets), // Mascotas
                  onPressed: () => Navigator.of(context).pop(Icons.pets),
                ),
                IconButton(
                  icon: const Icon(Icons.medical_services), // Salud
                  onPressed: () => Navigator.of(context).pop(Icons.medical_services),
                ),
                IconButton(
                  icon: const Icon(Icons.toys), // Juguetes
                  onPressed: () => Navigator.of(context).pop(Icons.toys),
                ),
                IconButton(
                  icon: const Icon(Icons.lightbulb), // Iluminación
                  onPressed: () => Navigator.of(context).pop(Icons.lightbulb),
                ),
                IconButton(
                  icon: const Icon(Icons.headphones), // Accesorios
                  onPressed: () => Navigator.of(context).pop(Icons.headphones),
                ),
                IconButton(
                  icon: const Icon(Icons.restaurant), // Cocina
                  onPressed: () => Navigator.of(context).pop(Icons.restaurant),
                ),
                IconButton(
                  icon: const Icon(Icons.beach_access), // Playa
                  onPressed: () => Navigator.of(context).pop(Icons.beach_access),
                ),
                IconButton(
                  icon: const Icon(Icons.fitness_center), // Gimnasio
                  onPressed: () => Navigator.of(context).pop(Icons.fitness_center),
                ),
                IconButton(
                  icon: const Icon(Icons.music_note), // Música
                  onPressed: () => Navigator.of(context).pop(Icons.music_note),
                ),
                IconButton(
                  icon: const Icon(Icons.umbrella), // Accesorios de lluvia
                  onPressed: () => Navigator.of(context).pop(Icons.umbrella),
                ),
                IconButton(
                  icon: const Icon(Icons.landscape), // Jardinería
                  onPressed: () => Navigator.of(context).pop(Icons.landscape),
                ),
                IconButton(
                  icon: const Icon(Icons.coffee), // Alimentos y bebidas
                  onPressed: () => Navigator.of(context).pop(Icons.coffee),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  void _addOrUpdateCategory() {
    if (_selectedIcon != null && _nameController.text.isNotEmpty) {
      setState(() {
        if (_isEditing && _editingCategoryId != null) {
          // Actualizar la categoría existente
          final categoryIndex = _dataService.categories.indexWhere((cat) => cat.idCategoria == _editingCategoryId);
          if (categoryIndex != -1) {
            _dataService.categories[categoryIndex] = Category(
              idCategoria: _editingCategoryId!,
              nombre: _nameController.text,
              icono: _selectedIcon!,
            );
          }
        } else {
          // Agregar nueva categoría
          _dataService.addCategory(Category(
            idCategoria: _dataService.categories.length + 1,
            nombre: _nameController.text,
            icono: _selectedIcon!,
          ));
        }
        _clearForm();
        _isEditing = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un nombre y seleccione un ícono')),
      );
    }
  }

  void _editCategory(Category category) {
    setState(() {
      _isEditing = true;
      _editingCategoryId = category.idCategoria;
      _nameController.text = category.nombre;
      _selectedIcon = category.icono;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _selectedIcon = null;
    _editingCategoryId = null;
    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Column(
        children: [
          _buildCategoryForm(),
          const SizedBox(height: 20),
          if (_isEditing) _buildCategoryForm(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _dataService.categories.length,
              itemBuilder: (context, index) {
                var category = _dataService.categories[index];
                return ListTile(
                  leading: Icon(category.icono),
                  title: Text('${category.idCategoria}:  ${category.nombre}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _dataService.deleteCategory(category.idCategoria);
                      });
                    },
                  ),
                  onTap: () {
                    _editCategory(category); // Editar categoría al hacer tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre de la categoría'),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(_selectedIcon ?? Icons.add_a_photo),
              onPressed: () {
                _selectIcon(context);
              },
            ),
            const Text('Seleccionar ícono'),
          ],
        ),
        ElevatedButton(
          onPressed: _addOrUpdateCategory,
          child: Text(_isEditing ? 'Actualizar Categoría' : 'Agregar Categoría'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _clearForm();
              _isEditing = false; // Ocultar formulario
            });
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
