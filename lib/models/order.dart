import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  //@JsonKey(name: 'Comanda_id')
  final int? id;
  final String? fecha;
  final String? hora;
  //@JsonKey(name: 'Total_platos')
  final int? totalPlatos;
  //@JsonKey(name: 'Precio_Total')
  final double? precioTotal;
  //@JsonKey(name: 'Tipo_Menu')
  final String? tipoMenu;
  //@JsonKey(name: 'idUsuario_fk')
  final int? idUsuarioFk;
  //@JsonKey(name: 'idMesa_fk')
  final int? idMesaFk;
  //@JsonKey(name: 'create_at')
  final String? createAt;
  //@JsonKey(name: 'update_at')
  final String? updateAt;

  Order({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.totalPlatos,
    required this.precioTotal,
    required this.tipoMenu,
    required this.idUsuarioFk,
    required this.idMesaFk,
    required this.createAt,
    required this.updateAt,
  });

  // Método toJson
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  factory Order.fromJson(Map<String, dynamic> json) {
    // Prioriza los campos con nombres específicos sobre los genéricos
    return Order(
      id: json['Comanda_id'] ?? int.tryParse(json['id'] ?? ''),
      fecha: json['fecha'],
      hora: json['hora'],
      totalPlatos: json['Total_platos'] ?? json['totalPlatos'],
      precioTotal: (json['Precio_Total'] ?? json['precioTotal'])?.toDouble(),
      tipoMenu: json['Tipo_Menu'] ?? json['tipoMenu'],
      idUsuarioFk: json['idUsuario_fk'] ?? json['idUsuarioFk'],
      idMesaFk: json['idMesa_fk'] ?? json['idMesaFk'],
      createAt: json['create_at'],
      updateAt: json['update_at'],
    );
  }
}
