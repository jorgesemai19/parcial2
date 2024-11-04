import 'package:flutter/material.dart';
import 'package:parcial2/services/sales_service.dart';
import 'package:parcial2/models/sale.dart';
import 'package:parcial2/screens/sale_detail_screen.dart';

class SalesQueryScreen extends StatefulWidget {
  const SalesQueryScreen({Key? key}) : super(key: key);

  @override
  _SalesQueryScreenState createState() => _SalesQueryScreenState();
}

class _SalesQueryScreenState extends State<SalesQueryScreen> {
  final SalesService _salesService = SalesService();
  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];
  String _clientSearchQuery = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _sales = _salesService.getAllSales(); // Cargar todas las ventas
    _filteredSales = _sales; // Inicialmente mostrar todas
  }

  // Filtrar ventas por fecha y cliente
  void _filterSales() {
    setState(() {
      _filteredSales = _sales.where((sale) {
        final matchesClient = sale.nombre.toLowerCase().contains(_clientSearchQuery.toLowerCase()) ||
            sale.apellido.toLowerCase().contains(_clientSearchQuery.toLowerCase()) ||
            sale.cedula.toLowerCase().contains(_clientSearchQuery.toLowerCase());
        final matchesDate = _selectedDate == null || sale.fecha.year == _selectedDate!.year &&
            sale.fecha.month == _selectedDate!.month &&
            sale.fecha.day == _selectedDate!.day;
        return matchesClient && matchesDate;
      }).toList();
    });
  }

  // Mostrar un date picker para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _filterSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas de Ventas'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda por cliente
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar cliente (nombre, apellido, cédula)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _clientSearchQuery = value;
                  _filterSales();
                });
              },
            ),
          ),
          // Botón para seleccionar la fecha
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Seleccionar fecha'),
            ),
          ),
          // Mostrar ventas filtradas
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                final sale = _filteredSales[index];
                return ListTile(
                  title: Text('${sale.nombre} ${sale.apellido} - \$${sale.total.toStringAsFixed(2)}'),
                  subtitle: Text('Fecha: ${sale.fecha.toString().split(' ')[0]}   id: ${sale.id}'), // Solo mostrar la fecha
                  onTap: () {
                    // Navegar a la pantalla de detalles de la venta
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaleDetailScreen(sale: sale),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
