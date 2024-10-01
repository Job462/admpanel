import 'package:flutter/foundation.dart';
import '../models/linea_model.dart';
import '../models/zona_model.dart';
import '../services/api_service.dart';

class ZonaNotifier with ChangeNotifier {
  final ApiService apiService;
  List<Zona> _zonas = [];
  List<Linea> _lineas = [];
  Zona? _selectedZona;

  List<Zona> get zonas => _zonas;
  List<Linea> get lineas => _lineas;
  Zona? get selectedZona => _selectedZona;

  ZonaNotifier(this.apiService) {
    _fetchZonas();
    _fetchLineas();
  }

  Future<void> _fetchZonas() async {
    _zonas = await apiService.getZonas();
    notifyListeners();
  }

  Future<void> _fetchLineas() async {
    _lineas = await apiService.getLineas();
    notifyListeners();
  }

  Future<void> saveZona(Zona zona) async {
    if (_selectedZona == null) {
      await apiService.addZona(zona);
    } else {
      await apiService.updateZona(_selectedZona!.id!, zona);
    }
    _fetchZonas();
    clearForm();
  }

  void clearForm() {
    _selectedZona = null;
    notifyListeners();
  }

  Future<void> deleteZona(int id) async {
    await apiService.deleteZona(id);
    _fetchZonas();
  }

  void selectZona(Zona zona) {
    _selectedZona = zona;
    notifyListeners();
  }

  void searchZona(String query) {
    if (query.isEmpty) {
      _fetchZonas();
    } else {
      final filteredZonas = _zonas.where((zona) {
        final zonaNombre = zona.nombre.toLowerCase();
        final searchLower = query.toLowerCase();
        return zonaNombre.contains(searchLower);
      }).toList();
      _zonas = filteredZonas;
      notifyListeners();
    }
  }
}
