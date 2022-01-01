import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';

class ListTileItem extends StatelessWidget {
  
  final Enfermedad enfermedad;

  const ListTileItem({Key? key, required this.enfermedad}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   final apiService = Provider.of<ApiService>(context);

    return ListTile(
                    title: Text(enfermedad.nombre.toUpperCase()),
                    leading: CircleAvatar(child:Text('${ enfermedad.id}'),),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        
                          IconButton(
                            icon: const Icon(Icons.edit,),
                            //hoverColor: Colors.green,
                            splashRadius: 20,
                            tooltip: 'Editar',
                            onPressed: (){
                              apiService.enfermedadSeleccionada = enfermedad;
                              Navigator.pushNamed(context, 'detail');
                            }
                          ),
                          IconButton(
                            hoverColor: Colors.red,
                            icon: const Icon(Icons.delete),
                            splashRadius: 20,
                            tooltip: 'Eliminar',
                            onPressed: (){
                              apiService.enfermedadSeleccionada = enfermedad;
                              apiService.deleteEnfermedad( enfermedad.id! );
                            }
                          ),

                        ],
                      ),
                    ),
                  );
  }
}