import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';
import 'package:sistema_experto_flutter/src/widgets/custom_button.dart';
import 'package:sistema_experto_flutter/src/widgets/listtile_character.dart';
import 'package:sistema_experto_flutter/src/widgets/listtile_check.dart';

class DetailsScreen extends StatefulWidget {

  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);
    final enfermedad = apiService.enfermedadSeleccionada;

    return Scaffold(
      appBar: AppBar(
        title: Align( child: Text('Detalles de ${enfermedad.nombre}'), alignment: Alignment.centerLeft,),
        actions: [
          CustomButton(
            ancho: 200,
            alto: 30,
            titulo: 'Agregar sintomas', 
            color: Colors.deepOrange,
            onPressed: addNewSintoma
          ),
        
          IconButton(onPressed: () async{
            await apiService.getAllEnfermedadesDesactivadas();
            await apiService.getAllCaracteristicasDesactivadas();
            Navigator.pushNamed(context, 'archive');
          }, icon: const Icon(Icons.settings))
        ],
      ),

      body: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text( enfermedad.nombre , style: const TextStyle( fontSize: 45, fontWeight: FontWeight.bold),),

                  //para una imagen
                  Container(
                    width: MediaQuery.of(context).size.width*0.3,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          titulo: apiService.isEdit ? 'Hecho' : 'EDITAR SINTOMAS', 
                          onPressed: 
                          apiService.isEdit 
                          ? (){ 
                            apiService.isEdit = false; 
                          }
                          : (){
                            apiService.isEdit = true; 
                          }, 
                          color: Colors.deepOrange, 
                          ancho: 200, 
                          alto:75
                        ),

                        CustomButton(titulo: 'ELIMINAR', onPressed: (){
                          print("Eliminar enfermedad");
                          //TODO: Habilitar este boton
                        }, color: Colors.red, alto: 75, ancho: 200,),
                      ],
                    ),
                  )

                ],
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: double.infinity,
              child: Column(
                children: [

                  Container(
                    width: double.infinity,
                    height: 35,
                    color: Colors.blueAccent,
                    child: const Center(child: Text('SINTOMAS DE ESTA ENFERMEDAD', style: TextStyle(color: Colors.white, fontSize: 23),)), 
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: apiService.isEdit ? apiService.caracteristicas.length : apiService.enfermedadCaracteristica.length,
                      itemBuilder: ( context, indice ){
                        final caracteristica = apiService.isEdit ? apiService.caracteristicas[indice] : apiService.enfermedadCaracteristica[indice];
                        return Column(
                          children: [

                            apiService.isEdit 
                            ? ListTileCheck(caracteristica: caracteristica)
                            : ListTileCharacter(caracteristica: caracteristica, indice: (indice+1),),

                            const Divider()
                          ],
                        );
                      }
                    ),
                  ),

                ],
              ),
            ),
            
          ],
        ),
      ),

    );
  }

   addNewSintoma( ){

    final textController = TextEditingController();
    
      showDialog(
        context: context, 
        builder: ( _ ) => AlertDialog(
            title: const Text('Nuevo sintoma:'),
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
                    String res = await apiService.postCaracteristica( textController.text);

                    Navigator.of(context).pop();
                    if( res.contains('msg') ){
                      showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text('El sintoma ya existe'),
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