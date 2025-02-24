import 'package:newtel_app_test/models/zona_model.dart';

class Linea {
  final int? id;
  final String nombre;
  final String proveedor;
  final String velocidad;
  final double precio;
  final String tipo;
  final String titular;
  final String celular;
  final String comentario;
  final String direccion;
  final String encargado;
  final DateTime createdAt;
  final List<Zona> zonas; 

  Linea({
    this.id, 
    required this.nombre,
    required this.proveedor,
    required this.velocidad,
    required this.precio,
    required this.tipo,
    required this.titular,
    required this.celular,
    required this.comentario,
    required this.direccion,
    required this.encargado,
    required this.createdAt,
    this.zonas = const [], 
  });

  factory Linea.fromMap(Map<String, dynamic> map) {
    return Linea(
      id: map['id'],
      nombre: map['nombre'],
      proveedor: map['proveedor'],
      velocidad: map['velocidad'],
      precio: double.parse(map['precio'].toString()),
      tipo: map['tipo'],
      titular: map['titular'],
      celular: map['celular'],
      comentario: map['comentario'],
      direccion: map['direccion'],
      encargado: map['encargado'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'proveedor': proveedor,
      'velocidad': velocidad,
      'precio': precio,
      'tipo': tipo,
      'titular': titular,
      'celular': celular,
      'comentario': comentario,
      'direccion': direccion,
      'encargado': encargado,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
