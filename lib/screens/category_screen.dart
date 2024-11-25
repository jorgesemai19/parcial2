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
  IconData? _selectedIcon; // Para almacenar el ícono seleccionado

  void _selectIcon(BuildContext context) async {
    IconData? icon = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un ícono'),
          content: Container(
            height: 300, // Establece una altura fija para el Container
            width: double.maxFinite, // Ancho máximo disponible
            child: GridView.count(
              shrinkWrap: true, // Esto permitirá que el GridView ajuste su tamaño
              crossAxisCount: 4,
              children: [
                IconButton(
                  icon: Icon(Icons.computer),
                  onPressed: () => Navigator.of(context).pop(Icons.computer),
                ),
                IconButton(
                  icon: Icon(Icons.sports_soccer),
                  onPressed: () => Navigator.of(context).pop(Icons.sports_soccer),
                ),
                IconButton(
                  icon: Icon(Icons.kitchen),
                  onPressed: () => Navigator.of(context).pop(Icons.kitchen),
                ),
                IconButton(
                  icon: Icon(Icons.school),
                  onPressed: () => Navigator.of(context).pop(Icons.school),
                ),
                // Puedes agregar más íconos aquí
              ],
            ),
          ),
        );
      },
    );

    if (icon != null) {
      setState(() {
        _selectedIcon = icon; // Guardamos el ícono seleccionado
      });
    }
  }


  // Función para agregar la categoría con el ícono seleccionado
  void _addCategory() {
    if (_selectedIcon != null && _nameController.text.isNotEmpty) {
      setState(() {
        _dataService.addCategory(Category(
          idCategoria: _dataService.categories.length + 1,
          nombre: _nameController.text,
          icono: _selectedIcon!, // Asignamos el ícono seleccionado
        ));
        _nameController.clear();
        _selectedIcon = null; // Reiniciamos el ícono después de agregar
      });
    } else {
      // Mostrar un mensaje de error si no se seleccionó un ícono o el nombre está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese un nombre y seleccione un ícono')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre de la categoría'),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(_selectedIcon ?? Icons.add_a_photo), // Ícono por defecto
                onPressed: () {
                  _selectIcon(context); // Mostrar el selector de íconos
                },
              ),
              Text('Seleccionar ícono'),
            ],
          ),
          ElevatedButton(
            onPressed: _addCategory, // Usamos la nueva función para agregar la categoría
            child: Text('Agregar Categoría'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dataService.categories.length,
              itemBuilder: (context, index) {
                var category = _dataService.categories[index];
                return ListTile(
                  leading: Icon(category.icono), // Mostrar el ícono
                  title: Text('${category.idCategoria}:  ${category.nombre}'), // Muestra el id y el nombre
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _dataService.deleteCategory(category.idCategoria);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
