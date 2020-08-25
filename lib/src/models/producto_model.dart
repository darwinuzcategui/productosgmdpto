// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  Object id;
  String codigo;
  String nombre;
  String unidadm;
  double precioDolares;
  double precioBss;
  bool disponible;
  String fotoUrl;
  Object grupo;
  Object marca;

  ProductoModel({
    this.id,
    this.codigo = '',
    this.nombre = '',
    this.unidadm,
    this.precioDolares = 100.0,
    this.precioBss = 100.0,
    this.disponible = true,
    this.fotoUrl = '',
    this.grupo = '5edd11f76c3b140017ee64e3',
    this.marca = '5edd120d6c3b140017ee64e4',
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id: json["_id"],
        codigo: json["codigo"],
        nombre: json["nombre"],
        unidadm: json["unidadm"],
        precioDolares: json["precioDolares"],
        precioBss: json["precioBss"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
        grupo: json["grupo"],
        marca: json["marca"],
      );
  // precioDolares: json["precioUn"].toDouble(),

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "nombre": nombre,
        "unidadm": unidadm,
        "precioDolares": precioDolares,
        "precioBss": precioBss,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
        "grupo": grupo,
        "marca": marca,
      };
}
