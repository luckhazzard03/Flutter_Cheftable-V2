import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int idUsuario;
  final String nombre;
  final String email;
  final String password;
  final String telefono;
  final int idRolesFk;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.password,
    required this.telefono,
    required this.idRolesFk,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método toJson
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // Método fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: int.parse(json['idUsuario']
          .toString()), // Asegúrate de convertir los valores a int
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      idRolesFk: int.parse(
          json['idRolesFk'].toString()), // Convertir a int si es necesario
      telefono: json['telefono'] as String,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
