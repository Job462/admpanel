import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newtel_app_test/models/plan_model.dart';
import '../models/zona_model.dart';
import '../models/linea_model.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<Zona>> getZonas() async {
    final response = await http.get(Uri.parse('$baseUrl/zonas'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Zona> zonas = body.map((dynamic item) => Zona.fromMap(item)).toList();
      return zonas;
    } else {
      throw Exception('Failed to load zonas');
    }
  }

  Future<List<Linea>> getLineas() async {
    final response = await http.get(Uri.parse('$baseUrl/lineas'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Linea> lineas = body.map((dynamic item) => Linea.fromMap(item)).toList();
      return lineas;
    } else {
      throw Exception('Failed to load lineas');
    }
  }

  Future<List<Plan>> getPlanes() async {
    final response = await http.get(Uri.parse('$baseUrl/planes'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Plan> planes = body.map((dynamic item) => Plan.fromMap(item)).toList();
      return planes;
    } else {
      throw Exception('Failed to load planes');
    }
  }

  Future<void> addZona(Zona zona) async {
    final response = await http.post(
      Uri.parse('$baseUrl/zonas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(zona.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add zona');
    }
  }

  Future<void> updateZona(int id, Zona zona) async {
    final response = await http.put(
      Uri.parse('$baseUrl/zonas/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(zona.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to update zona');
    }
  }

  Future<void> deleteZona(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/zonas/$id'),
    );

    if (response.statusCode != 204) {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to delete zona');
    }
  }

  Future<void> addPlan(Plan plan) async {
    final response = await http.post(
      Uri.parse('$baseUrl/planes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(plan.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add plan');
    }
  }

  Future<void> updatePlan(int id, Plan plan) async {
    final response = await http.put(
      Uri.parse('$baseUrl/planes/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(plan.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update plan');
    }
  }

  Future<void> deletePlan(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/planes/$id'),
    );

    if (response.statusCode != 204) {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to delete plan');
    }
  }
  Future<void> addLinea(Linea linea) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lineas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(linea.toMap()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add linea');
    }
  }

  Future<void> updateLinea(int id, Linea linea) async {
    final response = await http.put(
      Uri.parse('$baseUrl/lineas/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(linea.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update linea');
    }
  }

  Future<void> deleteLinea(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/lineas/$id'),
    );

    if (response.statusCode != 204) {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to delete linea');
    }
  }

}
