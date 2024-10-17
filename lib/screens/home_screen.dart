// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Carrito de Compras'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Bienvenido',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/products'); // Navegar a productos
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue, // Fondo azul
//                   foregroundColor: Colors.white, // Texto blanco
//                   minimumSize: const Size(200, 50), // Tamaño del botón
//                 ),
//                 child: const Text(
//                   'CRUD de Productos',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/categories'); // Navegar a categorías
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black, // Fondo negro
//                   foregroundColor: Colors.white, // Texto blanco
//                   minimumSize: const Size(200, 50), // Tamaño del botón
//                 ),
//                 child: const Text(
//                   'CRUD de Categorías',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
