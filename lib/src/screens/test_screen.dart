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
    final controllerRelaciones2 = ScrollController();

    return Scaffold(
      appBar: AppBar( 
        title: const Align(
          child: Text(
            'Test de enfermedades respiratorias', 
            style: TextStyle(fontSize: 20),), alignment: Alignment.centerLeft, 
        ),
        actions: [
          TextButton(onPressed: (){
            apiService.sintomasSeleccionados.clear();
            

            Navigator.pushNamed(context, 'question');
          }, child: const Text('Pasar a preguntas', style: TextStyle(color: Colors.white,)))
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
                    child: const Center(child: Text('Selecciona los sintomas que presentas', style: TextStyle(color: Colors.white, fontSize: 15),)), 
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
                    color: Colors.orange,
                    alto: 30,
                    onPressed: (){}
                  ),
                  SizedBox(height: 5,)
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
                  const Text('Sintomas seleccionados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Container(
                    color: Colors.grey[200],
                    height: 220,
                    width: double.infinity,
                    
                    child: GridView.builder(
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
                  const Text('Probabilidad de que sea la enfermedad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Container(
                    height: 200,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 5, mainAxisExtent: 60),
                      controller:scrollControllerProbabilidades,
                      itemCount: controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados).length,
                      itemBuilder: ( context, indice){
                        List<Enfermedad> list = controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados);
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO( 0, 0 ,0, (list[indice].conteo * 100 / list[indice].sintomas.length/100 ) ),
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
                  const Text('Relacion de enfermedades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Container(
                    height: 800,
                    color: Colors.red,
                    child: ListView.builder(

                      controller: controllerRelaciones,
                      itemCount: controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados).length,
                      itemBuilder: (context, indi){
                        List<Enfermedad> list = controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados);
                        return Container(
                          margin: EdgeInsets.only(top:10),
                          height: 25 *( list[indi].sintomas.length.toDouble() +1 ) ,
                          color: Colors.blue,
                          child: Row(
                            //TODO: Poner iconos de estado check error 
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text( list[indi].nombre ),  
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text( list[indi].sintomas[0].nombre ),
                                  //SizedBox(height: 10,),
                                  for (var sinto in list[indi].sintomas)
                                    Text( sinto.nombre )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  //Graficas
                  Container(
                    height: 400,
                    child: _showGraph( controller.diagnostico( apiService.enfermedades, apiService.sintomasSeleccionados) )
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

