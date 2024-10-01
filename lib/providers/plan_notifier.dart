import 'package:flutter/foundation.dart';
import '../models/plan_model.dart';
import '../services/api_service.dart';

class PlanNotifier with ChangeNotifier {
  final ApiService apiService;
  List<Plan> _planes = [];
  Plan? _selectedPlan;

  List<Plan> get planes => _planes;
  Plan? get selectedPlan => _selectedPlan;

  PlanNotifier(this.apiService) {
    _fetchPlanes();
  }

  Future<void> _fetchPlanes() async {
    _planes = await apiService.getPlanes();
    notifyListeners();
  }

  Future<void> savePlan(Plan plan) async {
    if (_selectedPlan == null) {
      await apiService.addPlan(plan);
    } else {
      await apiService.updatePlan(_selectedPlan!.id!, plan);
    }
    _fetchPlanes();
    clearForm();
  }

  void clearForm() {
    _selectedPlan = null;
    notifyListeners();
  }

  Future<void> deletePlan(int id) async {
    await apiService.deletePlan(id);
    _fetchPlanes();
  }

  void selectPlan(Plan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }

  void searchPlan(String query) {
    if (query.isEmpty) {
      _fetchPlanes();
    } else {
      final filteredPlanes = _planes.where((plan) {
        final planNombre = plan.nombre.toLowerCase();
        final searchLower = query.toLowerCase();
        return planNombre.contains(searchLower);
      }).toList();
      _planes = filteredPlanes;
      notifyListeners();
    }
  }
}
