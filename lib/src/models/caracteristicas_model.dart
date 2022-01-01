// To parse this JSON data, do
//
//     final caracteristicas = caracteristicaFromMap(jsonString);

import 'dart:convert';

class Caracteristicas {
    Caracteristicas({
        required this.caracteristicas,
    });

    List<Caracteristica> caracteristicas;

    factory Caracteristicas.fromJson(String str) => Caracteristicas.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Caracteristicas.fromMap(Map<String, dynamic> json) => Caracteristicas(
        caracteristicas: List<Caracteristica>.from(json["caracteristica"].map((x) => Caracteristica.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "caracteristica": List<dynamic>.from(caracteristicas.map((x) => x.toMap())),
    };
}

class Caracteristica {
    Caracteristica({
        this.id,
        required this.nombre,
        this.bandera,
        this.estado,
        this.createdAt,
        this.updatedAt,
    });

    int? id;
    String nombre;
    bool? bandera;
    bool? estado;
    DateTime? createdAt;
    DateTime? updatedAt;
    
    bool editing = false;

    factory Caracteristica.fromJson(String str) => Caracteristica.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Caracteristica.fromMap(Map<String, dynamic> json) => Caracteristica(
        id: json["id"],
        nombre: json["nombre"],
        bandera: json["bandera"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "bandera": bandera,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        // ignore: prefer_null_aware_operators
        "updatedAt": updatedAt == null ? null : updatedAt?.toIso8601String(),
    };
}
