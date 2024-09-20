// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['Comanda_id'] as num?)?.toInt(),
      fecha: json['fecha'] as String?,
      hora: json['hora'] as String?,
      totalPlatos: (json['Total_platos'] as num?)?.toInt(),
      precioTotal: (json['Precio_Total'] as num?)?.toDouble(),
      tipoMenu: json['Tipo_Menu'] as String?,
      idUsuarioFk: (json['idUsuario_fk'] as num?)?.toInt(),
      idMesaFk: (json['idMesa_fk'] as num?)?.toInt(),
      createAt: json['create_at'] as String?,
      updateAt: json['update_at'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'fecha': instance.fecha,
      'hora': instance.hora,
      'totalPlatos': instance.totalPlatos,
      'precioTotal': instance.precioTotal,
      'tipoMenu': instance.tipoMenu,
      'idUsuarioFk': instance.idUsuarioFk,
      'idMesaFk': instance.idMesaFk,
      'create_at': instance.createAt,
      'update_at': instance.updateAt,
    };
