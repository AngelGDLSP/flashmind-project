class UserModel {
  final int id;
  final String nombre;
  final String email;

  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_usuario'],
      nombre: json['nombre'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': id,
      'nombre': nombre,
      'email': email,
    };
  }
}
