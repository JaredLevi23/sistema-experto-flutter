import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/controller/test_controller.dart';
import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';

class QuestionsScreen extends StatefulWidget {

  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);
    
    Caracteristica sin = apiService.respuesta(false, null);

    return Scaffold(
      appBar: AppBar(
        title: Text('PREGUNTAS'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿Usted presenta ${sin.nombre}?', style: TextStyle(fontSize: 25),),
                ],
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    //Agregar enfermedades que tengan estas caracteristicas
                    sin = apiService.respuesta(true, sin);
                    if( sin.nombre == "encontrada" ){
                      //diagnosticamos
                      // final controller = TestController(sintomas: apiService.sintomasSeleccionados, enfermedades: apiService.enfermedades);
                      // final enfermedad = controller.diagnostico();

                      // showDialog(context: context, builder: (context){
                      //   return AlertDialog(title: Text('Usted podria padecer de ${enfermedad.nombre}'),);
                      // });

                      setState(() {
                        
                      });
                    }

                  }, 
                  child: const Text('SI', style: TextStyle(fontSize: 25),)),
                const SizedBox(height: 15,),
                TextButton(
                  onPressed: () {
                    //quitar enfermedades que tengan esta caracteristica
                    sin = apiService.respuesta(false, sin);
                    if( sin.nombre == "encontrada" ){
                      //diagnosticamos
                      
                      final controller = TestController();
                      //final enfermedad = controller.diagnostico();

                      showDialog(context: context, builder: (context){
                        return AlertDialog(title: Text('Usted podria padecer de {enfermedad.nombre}'),);
                      });

                    


                      
                      
                    }

                    setState(() {
                        
                      });

                    
                  }, 
                  child: const Text('NO', style: TextStyle(fontSize: 25),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
