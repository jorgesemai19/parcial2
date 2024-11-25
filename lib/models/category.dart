import 'package:flutter/material.dart';

class Category {
  int idCategoria;
  String nombre;
  IconData icono; // Nuevo atributo para almacenar el ícono de la categoría

  Category({
    required this.idCategoria,
    required this.nombre,
    this.icono = Icons.category, // Parámetro obligatorio para el ícono
  });
}
