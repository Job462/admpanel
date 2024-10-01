class Zona {
  final int? id;
  final String nombre;
  final int idLinea;
  final String? comentario;
  DateTime createdAt;

  Zona({
    this.id,
    required this.nombre,
    required this.idLinea,
    required this.comentario,
    required this.createdAt,
  });

  factory Zona.fromMap(Map<String, dynamic> map) { 
    return Zona(
      id: map['id'],
      nombre: map['nombre'],
      idLinea: map['id_linea'] ?? 0,

      comentario: map['comentario'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'nombre': nombre,
      'id_linea': idLinea,
      'comentario': comentario,
      'created_at': createdAt.toIso8601String(),
    };
  }
}