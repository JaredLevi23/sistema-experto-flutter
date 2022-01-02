import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/controller/test_controller.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';
import 'package:sistema_experto_flutter/src/widgets/custom_button.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);
    final controller = TestController();

    final scrollControllerSintomas = ScrollController();
    final scrollControllerDetalles = ScrollController();
    final scrollGridSeleccionados = ScrollController();
    final scrollControllerProbabilidades = ScrollController();
    final controllerRelaciones = ScrollController();

    return Scaffold(
      appBar: AppBar( 
        title: const Align(
          child: Text(
            'Test de enfermedades respiratorias', 
            style: TextStyle(fontSize: 20),), alignment: Alignment.centerLeft, 
        ),
        actions: [
          TextButton(onPressed: () async{
            apiService.sintomasSeleccionados.clear();
            apiService.sintomasNOSeleccionados.clear();
            await apiService.loadDataReset();

            setState(() {
              
            });
          }, child: const Text('Reiniciar', style: TextStyle(color: Colors.white,)))
        ],
      ),

      body: SizedBox(
        width: double.infinity,
        child: Row(
          children: [

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: double.infinity,
              child: Column(
                children: [

                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.blueAccent,
                    child: const Center(child: Text('Selecciona los sintomas que presentas', style: TextStyle(color: Colors.white, fontSize: 17),)), 
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollControllerSintomas,
                      itemCount: apiService.caracteristicas.length,
                      itemBuilder: ( context, indice ){
                        final caracteristica = apiService.caracteristicas[indice];
                        return ListTile(
                          title: Text(caracteristica.nombre, style: TextStyle(fontSize: 15),),
                          leading: CircleAvatar(child: Text( '${indice+1}' ),),
                          trailing: Checkbox(
                            value: caracteristica.bandera,
                            onChanged: (value){
                              if(value == true){
                                apiService.sintomasSeleccionados.add( caracteristica );
                                caracteristica.bandera = true;
                              }else{
                                apiService.sintomasSeleccionados.removeWhere((element) => element.nombre == caracteristica.nombre);
                                caracteristica.bandera = false;
                              }

                              setState(() {
                                
                              });
                            },
                          ),
                        );
                      }
                    ),
                  ),

                  CustomButton(
                    titulo: 'Inferir', 
                    color: Colors.deepOrange,
                    alto: 30,
                    onPressed: ()async{
                      
                      //Verifica si ya se seleccionaron sintomas
                      if(apiService.sintomasSeleccionados.isEmpty ){
                        return showDialog(context: context, builder: (context){
                          return const AlertDialog(
                            title: Text('SELECCIONA ALGUN SINTOMA'),
                          );
                        });
                      }

                      bool encontrado = false;
                      late Enfermedad posible;
                      List<Enfermedad> verificadas = []; 
                      int mayor = 1;
                      int total = 0;
                      
                    do{

                        mayor = 1; // Reiniciar las variables
                        total = 0; // reiniciar cuantas enfermedades son 
                      //Saber quien tiene mas sintomas 
                        for (var enfer in controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados )) {
                          if( enfer.conteo >= mayor && !verificadas.contains(enfer) && enfer.estado != false){
                            mayor = enfer.conteo;
                            posible = enfer;

                            if(enfer.conteo>=1){
                              total++;
                            }
                          }
                        }

                        if( total != 0){
                          //Mostrar las preguntas de las que aun no ha verificado
                      for (var sint in posible.sintomas) {
                        if( !apiService.sintomasSeleccionados.contains(sint)){
                          await showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Text('Determinando si es ${posible.nombre}'),
                              content: Text('¿Usted padece de ${sint.nombre}?'),
                              actions: [
                                TextButton(onPressed: (){
                                  //Cambiar estado del sintoma
                                  sint.bandera = true;
                                  apiService.sintomasSeleccionados.add(sint);
                                  setState(() {
                                  });
                                  Navigator.pop(context);
                                }, child: const Text('Si')),
                                TextButton(onPressed: (){
                                  //Cambiar el estado del sintoma
                                  sint.bandera = false;
                                  apiService.sintomasNOSeleccionados.add(sint);
                                  Navigator.pop(context);
                                }, child: const Text('No'))
                              ]
                            );
                          });
                        }
                      }

                      verificadas.add( posible );

                      //Saber quien tiene mas sintomas 
                        total = 0;
                        for (var enfer in controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados)) {
                          if(enfer.conteo>=1){
                            total++;
                          }
                        }

                      encontrado = true;
                      for (var sin in posible.sintomas) {
                        if( sin.bandera == false){
                          encontrado = false;
                        }  
                      }

                      if( encontrado == true){
                        showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text('Usted podria padecer de ${posible.nombre}'),
                        );
                        });
                      }
                      }

                      print('UNA VUELTA MAS');
                      //Sino es repetir lo de arriba
                      } while( encontrado == false && 
                      verificadas.length <= total );
                      
                      if( encontrado == false){
                         showDialog(context: context, builder: (context){
                        return const AlertDialog(
                          title: Text('Seleccione mas sintomas para determinar su enfermedad'),
                        );
                        });
                      }
                      setState(() {
                        
                      });
                    }
                  ),
                  const SizedBox(height: 5,)
                ],
              ),
            ),

            Container(
              width: 1,
              height: double.infinity,
              color: Colors.black54,
            ),

            Expanded(
              child: ListView(
                controller: scrollControllerDetalles,
                children: [
                  //Datos seleccionados
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Sintomas seleccionados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    width: double.infinity,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      scrollDirection: Axis.vertical,
                      controller: scrollGridSeleccionados,            
                      
                      itemCount: apiService.sintomasSeleccionados.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8,mainAxisSpacing: 1), 
                      itemBuilder: (context, indice){
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Center(child: Text(apiService.sintomasSeleccionados[indice].nombre, maxLines: 4, style: TextStyle(color: Colors.white),)),
                        );
                      }
                    ),
                  ),

                  //Probabilidades
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Probabilidad de que sea la enfermedad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Container(
                    height: 200,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 5, mainAxisExtent: 60),
                      controller:scrollControllerProbabilidades,
                      itemCount: controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados).length,
                      itemBuilder: ( context, indice){
                        List<Enfermedad> list = controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados);
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO( 0, 0 ,0, ( list[indice].conteo * 100 / list[indice].sintomas.length/100 ).isNaN ? 0 :  list[indice].conteo * 100 / list[indice].sintomas.length/100),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          //padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(top: 5, right:10, left: 10),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              Text( list[indice].nombre , style: TextStyle( fontSize: 12, color: Colors.white ),),
                              Text( ' ${( list[indice].conteo * 100 / list[indice].sintomas.length).toStringAsFixed(2) }%', style: const TextStyle( fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold ),),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ),

                  //Objetos
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Relacion de enfermedades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Container(
                    height: 800,
                    
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      controller: controllerRelaciones,
                      itemCount: controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados).length,
                      itemBuilder: (context, indi){
                        List<Enfermedad> list = controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados);
                        return Container(
                          margin: const EdgeInsets.only(top:10),
                          height: 25 *( list[indi].sintomas.length.toDouble() +1 ) ,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Align(
                                  child: Text(
                                   '${list[indi].nombre}\nSintomas: ${list[indi].conteo}', 
                                   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                   textAlign: TextAlign.center,
                                  ), 
                                alignment: Alignment.center,
                                )
                              ),  
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Text( list[indi].sintomas[0].nombre ),
                                    //SizedBox(height: 10,),
                                    for (var sinto in list[indi].sintomas)
                                      Row(
                                        children: [
                                          Icon( sinto.bandera==true ? Icons.check : Icons.close, color: sinto.bandera==true ? Colors.red : Colors.black),
                                          Text( sinto.nombre ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  //Graficas
                  const Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text('Gráfica de datos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Container(
                    height: 400,
                    child: _showGraph( controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados,apiService.sintomasNOSeleccionados) )
                  ),
                ],
              )              
            )

          ],
        ),
      ),
    );
  }

  Widget _showGraph(List<Enfermedad> list ){

    late Map<String, double> dataMap = {
    };

    for (var element in list) { 
      dataMap.putIfAbsent(element.nombre, () => element.conteo.toDouble());
    }

    if(list.isEmpty){
      return Container(
        child: CircleAvatar(radius: 50,),
      );
    }
    

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: PieChart(
        dataMap: dataMap,
        centerText: 'Probabilidades',
        chartRadius: 550,
        
      )
      );
  }
}

