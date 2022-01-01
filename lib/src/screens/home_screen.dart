import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';
import 'package:sistema_experto_flutter/src/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sistema experto para identificar enfermedades', style: TextStyle(fontSize: 25),)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child:  _bodyApp( apiService: apiService,)
      ),
    );
  }
}

// ignore: camel_case_types
class _bodyApp extends StatelessWidget {
  _bodyApp({Key? key, required this.apiService}) : super(key: key);

  ApiService apiService;

  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const _HeaderApp(),

        CustomButton(
          titulo: 'Comenzar', 
          onPressed: (){ 
            //Cargar data a enfermedades
            apiService.cargarData();
            Navigator.pushNamed(context, 'test');
          }, color: Colors.blue, ancho: 250, alto: 75,),


        IconButton(
          iconSize: 50,
          onPressed: ()async{
            await apiService.getAllEnfermedades();
            await apiService.getAllCaracteristicas();
            await apiService.getAllEnfermedadCaracteristica();
            
            Navigator.pushNamed(context, 'dashboard');
          }, icon: Icon(Icons.settings, color: Colors.blue.shade300 ,)
        ),

        TextButton(onPressed: (){
          showDialog(context: context, builder:(context){
            return Container(
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.hashCode *0.5,
              child: AlertDialog(
                title: Column(
                  children: const [
                    Text('Acerca de', style: TextStyle(fontSize: 25),),
                    SizedBox(height: 15,),
                    Text('Este sistema experto permite determinar las enfermedades con los sintomas que el usuario introduzca.', style: TextStyle(fontSize: 18),),
                  ],
                ),
              ),
            );
          });
        }, child: const Text('Acerca de'))
      ],
    );
  }
}

class _HeaderApp extends StatelessWidget {
  const _HeaderApp({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('INSTITUTO TECNOLÓGICO DE ZACATEPEC', style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
        const SizedBox(height: 15 ,),
        const Text('PROGRAMACIÓN LÓGICA Y FUNCIONAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ), textAlign: TextAlign.center, ),
        const SizedBox(height: 15 ,),
        const Text('JARED LEVI GONZÁLEZ AYALA', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        const Text('Ing. Sistemas Computacionales', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
        Container(width: 100, height: 100, child: Image(image: AssetImage('assets/itz.png'), fit:BoxFit.fill,))
        
      ],
    );
  }
}