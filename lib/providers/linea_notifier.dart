import 'package:flutter/foundation.dart';
import '../models/linea_model.dart';
import '../services/api_service.dart';

class LineaNotifier with ChangeNotifier {
  final ApiService lineaApiService;
  List<Linea> _lineas = [];
  Linea? _selectedLinea;

  List<Linea> get lineas => _lineas;
  Linea? get selectedLinea => _selectedLinea;

  LineaNotifier(this.lineaApiService) {
    _fetchLineas();
  }

  Future<void> _fetchLineas() async {
    _lineas = await lineaApiService.getLineas();
    notifyListeners();
  }

  Future<void> saveLinea(Linea linea) async {
    if (_selectedLinea == null) {
      await lineaApiService.addLinea(linea);
    } else {
      await lineaApiService.updateLinea(_selectedLinea!.id!, linea);
    }
    _fetchLineas();
    clearForm();
  }

  void clearForm() {
    _selectedLinea = null;
    notifyListeners();
  }

  Future<void> deleteLinea(int id) async {
    await lineaApiService.deleteLinea(id);
    _fetchLineas();
  }

  void selectLinea(Linea linea) {
    _selectedLinea = linea;
    notifyListeners();
  }

  void searchLinea(String query) {
    if (query.isEmpty) {
      _fetchLineas();
    } else {
      final filteredLineas = _lineas.where((linea) {
        final lineaNombre = linea.nombre.toLowerCase();
        final searchLower = query.toLowerCase();
        return lineaNombre.contains(searchLower);
      }).toList();
      _lineas = filteredLineas;
      notifyListeners();
    }
  }
}
