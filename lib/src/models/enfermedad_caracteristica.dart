import 'dart:convert';

class Relaciones {
    Relaciones({
        required this.relaciones,
    });

    List<Elemento> relaciones;

    factory Relaciones.fromJson(String str) => Relaciones.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Relaciones.fromMap(Map<String, dynamic> json) => Relaciones(
        relaciones: List<Elemento>.from(json["relaciones"].map((x) => Elemento.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "relaciones": List<dynamic>.from(relaciones.map((x) => x.toMap())),
    };
}

class Elemento {
    Elemento({
        required this.idEnfermedad,
        required this.idCaracteristica,
    });

    int idEnfermedad;
    int idCaracteristica;

    factory Elemento.fromJson(String str) => Elemento.fromMap(json.decode(str));

    factory Elemento.fromJson2(String str) => Elemento.fromMap2(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Elemento.fromMap(Map<String, dynamic> json) => Elemento(
        idEnfermedad: json["idEnfermedad"],
        idCaracteristica: json["idCaracteristica"],
    );

    factory Elemento.fromMap2(Map<String, dynamic> json) => Elemento(
        idEnfermedad: json["relacion"]["idEnfermedad"],
        idCaracteristica: json["relacion"]["idCaracteristica"],
    );

    Map<String, dynamic> toMap() => {
        "idEnfermedad": idEnfermedad,
        "idCaracteristica": idCaracteristica,
    };
}
