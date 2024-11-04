// screens/category_screen.dart
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                _dataService.addCategory(Category(
                    idCategoria: _dataService.categories.length + 1,
                    nombre: _nameController.text));
              });
              _nameController.clear();
            },
            child: Text('Agregar Categoría'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dataService.categories.length,
              itemBuilder: (context, index) {
                var category = _dataService.categories[index];
                return ListTile(
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
