import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(title: const Align(child: Text('DATOS DESACTIVADOS'), alignment: Alignment.centerRight,),),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [

              Container(
                width: MediaQuery.of(context).size.width*0.5,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 35,
                      color: Colors.blueAccent,
                      child: const Center(child: Text('ENFERMEDADES', style: TextStyle(color: Colors.white, fontSize: 23),)), 
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: apiService.enfermedadesDesactivadas.length,
                        itemBuilder: (context, indice ){
                          final enfermedad = apiService.enfermedadesDesactivadas[indice];
                          return ListTile(

                            title: Text( enfermedad.nombre ),
                            subtitle: const Text('Desactivada'),
                            leading: CircleAvatar( child: Text( '${indice+1}' ),),
                            trailing: FlatButton(
                              child: Text('Activar'),
                              onPressed: (){
                                apiService.activarEnfermedad( enfermedad.id!);
                              },
                            ),
                          );
                        }
                      )
                    )
                  ],
                ),
              ),

              Container(height: double.infinity, width: 5, color: Colors.blue,),

              Expanded(child:  Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 35,
                      color: Colors.blueAccent,
                      child: const Center(child: Text('SINTOMAS', style: TextStyle(color: Colors.white, fontSize: 23),)), 
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: apiService.caracteristicasDesactivadas.length,
                        itemBuilder: (context, indice ){
                          final caracteristica = apiService.caracteristicasDesactivadas[indice];
                          return ListTile(

                            title: Text( caracteristica.nombre),
                            subtitle: const Text('Desactivado'),
                            leading: CircleAvatar( child: Text( '${indice+1}' ),),
                            trailing: FlatButton(
                              child: Text('Activar'),
                              onPressed: ()async{
                                await apiService.activarSintoma( caracteristica.id!);
                              },
                            ),
                          );
                        }
                      )
                    )
                  ],
                ),)
            ],
          ) ,
      )),
    );
  }
}