// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      idUsuario: (json['idUsuario'] as num).toInt(),
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      telefono: json['telefono'] as String,
      idRolesFk: (json['idRolesFk'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'idUsuario': instance.idUsuario,
      'nombre': instance.nombre,
      'email': instance.email,
      'password': instance.password,
      'telefono': instance.telefono,
      'idRolesFk': instance.idRolesFk,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
