import 'package:flutter/material.dart';
import 'package:newtel_app_test/services/api_service.dart';
import 'package:newtel_app_test/services/cliente_service.dart';
import 'package:newtel_app_test/models/cliente_model.dart';
import '../models/plan_model.dart';
import '../models/zona_model.dart';

class ClienteNotifier with ChangeNotifier {
  final ClienteService _clienteService;
  final ApiService _apiService;

  List<Cliente> _clientes = [];
  List<Zona> _zonas = [];
  List<Plan> _planes = [];
  Cliente? _selectedCliente;
  Plan? _selectedPlan;
  Zona? _selectedZona;

  List<Cliente> get clientes => _clientes;
  List<Zona> get zonas => _zonas;
  List<Plan> get planes => _planes;
  Cliente? get selectedCliente => _selectedCliente;
  Plan? get selectedPlan => _selectedPlan;
  Zona? get selectedZona => _selectedZona;

  ClienteNotifier(this._clienteService, this._apiService) {
    _fetchClientes();
    _fetchZonas();
    _fetchPlanes();
  }

  Future<void> _fetchClientes() async {
    _clientes = await _clienteService.getClientes();
    notifyListeners();
  }

  Future<void> _fetchZonas() async {
    _zonas = await _apiService.getZonas();
    notifyListeners();
  }

  Future<void> _fetchPlanes() async {
    _planes = await _apiService.getPlanes();
    notifyListeners();
  }

  Future<void> saveCliente(Cliente cliente) async {
    if (_selectedCliente == null) {
      await _clienteService.insertCliente(cliente);
    } else {
      await _clienteService.updateCliente(cliente);
    }
    _fetchClientes();
    clearForm();
  }

  void clearForm() {
    _selectedCliente = null;
    _selectedPlan = null;
    _selectedZona = null; // Clear selectedZona when clearing form
    notifyListeners();
  }

  Future<void> deleteCliente(int id) async {
    await _clienteService.deleteCliente(id);
    _fetchClientes();
  }

  void selectCliente(Cliente cliente) {
    _selectedCliente = cliente;
    notifyListeners();
  }

  void selectClientePlan(int planId) {
    _selectedPlan = _planes.firstWhere((plan) => plan.id == planId, orElse: () => Plan(
      id: 0, nombre: 'Desconocido', costo: 0, comentario: '', createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void selectClienteZona(int zonaId) {
    _selectedZona = _zonas.firstWhere((zona) => zona.id == zonaId, orElse: () => Zona(
      id: 0, nombre: 'Desconocido', comentario: '', idLinea: 0, createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void searchCliente(String query) {
    if (query.isEmpty) {
      _fetchClientes();
    } else {
      final filteredClientes = _clientes.where((cliente) {
        final clienteNombre = cliente.nombre.toLowerCase();
        final searchLower = query.toLowerCase();
        return clienteNombre.contains(searchLower);
      }).toList();
      _clientes = filteredClientes;
      notifyListeners();
    }
  }

  String getZonaNombre(int id) {
    final zona = _zonas.firstWhere((zona) => zona.id == id, orElse: () => Zona(
      id: 0, nombre: 'Desconocido', comentario: '', idLinea: 0, createdAt: DateTime.now(),
    ));
    return zona.nombre;
  }

  String getPlanNombre(int id) {
    final plan = _planes.firstWhere((plan) => plan.id == id, orElse: () => Plan(
      id: 0, nombre: 'Desconocido', costo: 0, comentario: '', createdAt: DateTime.now(),
    ));
    return plan.nombre;
  }
}
