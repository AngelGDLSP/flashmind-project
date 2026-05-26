class ThemeModel {
  final int id;
  final String nombre;
  final String descripcion;
  final DateTime fechaCreacion;
  final int idCategoria;
  final int idUsuario;

  ThemeModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.fechaCreacion,
    required this.idCategoria,
    required this.idUsuario,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      id: json['id_tema'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      idCategoria: json['id_categoria'],
      idUsuario: json['id_usuario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tema': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'id_categoria': idCategoria,
      'id_usuario': idUsuario,
    };
  }
}
