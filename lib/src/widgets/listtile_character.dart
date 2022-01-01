import 'package:flutter/material.dart';
import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';

class ListTileCharacter extends StatelessWidget {
  
  final Caracteristica caracteristica;
  final int indice;

  const ListTileCharacter({Key? key, required this.caracteristica, required this.indice}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(caracteristica.nombre.toUpperCase()),
      leading: CircleAvatar(child:Text('$indice'),),
    );
  }
}