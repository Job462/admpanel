class Plan {
  final int? id;
  final String nombre;
  final double costo;
  final String comentario;
  final DateTime createdAt;
  
  Plan({
    this.id,
    required this.nombre,
    required this.costo,
    required this.comentario,
    required this.createdAt,
  });

  factory Plan.fromMap(Map<String, dynamic> map) { 
    return Plan(
      id: map['id'],
      nombre: map['nombre'],
      costo: map['costo'].toDouble(),
      comentario: map['comentario'],
      createdAt: DateTime.parse(map['created_at']),       
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'nombre': nombre,
      'costo': costo,
      'comentario': comentario,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
