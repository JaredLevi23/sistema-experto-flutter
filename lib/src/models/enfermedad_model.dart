// To parse this JSON data, do
//
//     final enfermedades = enfermedadFromMap(jsonString);

import 'dart:convert';

import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';

class Enfermedades {
    Enfermedades({
        required this.enfermedades,
    });

    List<Enfermedad> enfermedades;

    factory Enfermedades.fromJson(String str) => Enfermedades.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Enfermedades.fromMap(Map<String, dynamic> json) => Enfermedades(
        enfermedades: List<Enfermedad>.from(json["enfermedad"].map((x) => Enfermedad.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "enfermedad": List<dynamic>.from(enfermedades.map((x) => x.toMap())),
    };
}

class Enfermedad {
    Enfermedad({
        this.id,
        required this.nombre,
        this.bandera,
        this.estado,
        this.createdAt,
        this.updatedAt,
    });

    int ?id;
    String nombre;
    bool ?bandera;
    bool ?estado;
    DateTime? createdAt;
    DateTime ?updatedAt;

    List<Caracteristica> sintomas = [];
    int conteo = 0;

    factory Enfermedad.fromJson(String str) => Enfermedad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Enfermedad.fromMap(Map<String, dynamic> json) => Enfermedad(
        id: json["id"],
        nombre: json["nombre"],
        bandera: json["bandera"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombre": nombre,
        "bandera": bandera,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
