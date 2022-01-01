import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';
import 'package:flutter/material.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';
import 'package:sistema_experto_flutter/src/widgets/listtile_item.dart';

class DashboardScreen extends StatefulWidget {
   const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Enfermedad> enfermedades = [];

  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Align( child:  Text('Dashboard'), alignment: Alignment.centerLeft,),
        actions: [
          IconButton(onPressed: () async{
            await apiService.getAllEnfermedadesDesactivadas();
            await apiService.getAllCaracteristicasDesactivadas();
            Navigator.pushNamed(context, 'archive');
          }, icon: const Icon(Icons.settings))
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addNewEnfermedad,
        tooltip: 'Agregar',
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 25,
            color: Colors.blueAccent,
            child: const Center(child: Text('Lista de enfermedades respiratorias', style: TextStyle(color: Colors.white, fontSize: 15),)), 
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              itemCount: apiService.enfermedades.length,
              itemBuilder: (_, indice){
                return Column(
                  children: [
                   ListTileItem( enfermedad: apiService.enfermedades[indice], ),
                    const Divider()
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
    
  }

  addNewEnfermedad(){

    final textController = TextEditingController();
    
      showDialog(
        context: context, 
        builder: ( _ ) => AlertDialog(
            title: const Text('Nueva enfermedad:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                textColor: Colors.blue,
                child: const Text('Agregar'),
                onPressed: () async{
                  
                  if( textController.text.isNotEmpty ){
                    final apiService = Provider.of<ApiService>(context, listen: false);
                    String res = await apiService.postEnfermedad( textController.text);

                    Navigator.of(context).pop();
                    if( res.contains('msg') ){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text('La enfermedad ya existe'),
                        );
                      });
                    }
                    if( res.contains('error') ){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text('Verifica tu conexion'),
                        );
                      });
                    }
                    if( res.contains('id') ){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text('Guardado correctamente'),
                        );
                      });
                    }

                    
                  }

                }
              ),
              MaterialButton(
                textColor: Colors.red,
                child: const Text('Cancelar'),
                onPressed: (){
                      Navigator.of(context).pop();
                }
              )
            ],
          )
      );

  }
 
}