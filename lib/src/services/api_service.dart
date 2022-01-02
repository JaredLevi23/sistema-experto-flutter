
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_caracteristica.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';
import 'package:http/http.dart' as http;

class ApiService with ChangeNotifier{

  // ignore: non_constant_identifier_names
  final _URL_BASE = 'http://192.168.100.5:8081/api';

  bool _isLoading = false;
  bool _isEdit = false;
  bool get isEdit => _isEdit;

  int _contador = 0;

  int get contador => _contador;

  set contador(int contador) {
    _contador = contador;
    notifyListeners();
  }

  set isEdit(bool isEdit) {
    _isEdit = isEdit;
    notifyListeners();
  }
  
  List<Enfermedad> enfermedades = [];
  List<Caracteristica> caracteristicas = [];
  List<Elemento> relaciones = [];

  late Enfermedad _enfermedadSeleccionada;
  List<Caracteristica> enfermedadCaracteristica = [];
  late List<Elemento> caracteristicasSeleccionadas = [];

  List<Caracteristica> caracteristicasDesactivadas = [];
  List<Enfermedad> enfermedadesDesactivadas = [];

  List<Caracteristica> sintomasSeleccionados = [];
  List<Caracteristica> sintomasNOSeleccionados = [];
  //List<Enfermedad> enfermedadesRestantes = [];

  Enfermedad get enfermedadSeleccionada => _enfermedadSeleccionada;

  set enfermedadSeleccionada(Enfermedad enfermedadSeleccionada) {
    _enfermedadSeleccionada = enfermedadSeleccionada;
    getEnfermedadCaracteristica();
    notifyListeners();
  }

  ApiService(){
    getAllEnfermedades();
    getAllCaracteristicas();
    getAllEnfermedadCaracteristica();
  }

//ENFERMEDADES
  getAllEnfermedades() async {
    enfermedades.clear();
    final url = '$_URL_BASE/enfermedades/';
    final resp = await http.get(Uri.parse(url));
    final enfermedadesResp = Enfermedades.fromJson(resp.body);

    enfermedades.addAll( enfermedadesResp.enfermedades );
    //print('datos cargados');
    notifyListeners();
  }

    getAllEnfermedadesDesactivadas()async{
    enfermedadesDesactivadas.clear();
    final url = '$_URL_BASE/enfermedades/archivo';
    final resp = await http.get(Uri.parse(url));
    final enfermedadesResp = Enfermedades.fromJson(resp.body);
    enfermedadesDesactivadas.addAll( enfermedadesResp.enfermedades );
    notifyListeners();
  }

  Future<String> postEnfermedad( String nombre ) async {
    final url = '$_URL_BASE/enfermedades/';
    final resp = await http.post(
      Uri.parse(url), 
      body: jsonEncode({ "nombre": nombre.toUpperCase() }), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
    }, );

    if(resp.body.contains('msg')){
      return resp.body;  
    }

    final nueva = Enfermedad.fromJson( resp.body );
    enfermedades.add( nueva );
    notifyListeners();
    return resp.body;
  }

  Future<String> deleteEnfermedad(int id ) async {
    final url = '$_URL_BASE/enfermedades/';
    final resp = await http.delete(
    
    Uri.parse(url), 
      body: jsonEncode({ "id": id }), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, 
    );
    getAllEnfermedades();
    notifyListeners();
    return resp.body;
  }

  Future<String> activarEnfermedad(int id ) async {
    final url = '$_URL_BASE/enfermedades/$id';
    final resp = await http.put(Uri.parse(url), body: jsonEncode({ "actualizar":"si" }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },  );
    print( url );
    getAllEnfermedades();
    getAllEnfermedadesDesactivadas();
    notifyListeners();
    return resp.body;
  }

  //SINTOMAS

  getAllCaracteristicas()async{
    caracteristicas.clear();
    final url = '$_URL_BASE/caracteristicas/';
    final resp = await http.get(Uri.parse(url));
    final caracteristicasResp = Caracteristicas.fromJson(resp.body);
    caracteristicas.addAll( caracteristicasResp.caracteristicas );
    notifyListeners();
  }

  getAllCaracteristicasDesactivadas()async{
    caracteristicasDesactivadas.clear();
    final url = '$_URL_BASE/caracteristicas/archivo';
    final resp = await http.get(Uri.parse(url));
    final caracteristicasResp = Caracteristicas.fromJson(resp.body);
    caracteristicasDesactivadas.addAll( caracteristicasResp.caracteristicas );
    notifyListeners();
  }


  Future<String> postCaracteristica( String nombre ) async {
    final url = '$_URL_BASE/caracteristicas/';
    final resp = await http.post(
      Uri.parse(url), 
      body: jsonEncode({ "nombre": nombre.toUpperCase() }), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, 
    );

    if(resp.body.contains('msg')){
      return resp.body;
    }

    print(resp.body);

    final nueva = Caracteristica.fromJson( resp.body );
    caracteristicas.add( nueva );
    notifyListeners();
    return resp.body;
  }

  Future<String> deleteSintoma(int id ) async {
    final url = '$_URL_BASE/caracteristicas/$id';
    final resp = await http.delete(Uri.parse(url));
    print( url );
    getAllCaracteristicas();
    notifyListeners();
    return resp.body;
  }

  Future<String> putSintoma(int id, String nombre ) async {
    final url = '$_URL_BASE/caracteristicas/$id';
    final resp = await http.put(Uri.parse(url), body: jsonEncode({ "nombre": nombre.toUpperCase() }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },  );
    print( url );
    getAllCaracteristicas();
    notifyListeners();
    return resp.body;
  }

  Future<String> activarSintoma(int id ) async {
    final url = '$_URL_BASE/caracteristicas/$id';
    final resp = await http.put(Uri.parse(url), body: jsonEncode({ "actualizar":"si" }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },  );
    print( url );
    getAllCaracteristicas();
    getAllCaracteristicasDesactivadas();
    notifyListeners();
    return resp.body;
  }



  //Relaciones
   getAllEnfermedadCaracteristica()async{
    final url = '$_URL_BASE/relaciones/';
    final resp = await http.get(Uri.parse(url));
    //print(resp.body);
    final items = Relaciones.fromJson(resp.body);
    relaciones.addAll( items.relaciones );
    notifyListeners();
  }

  getEnfermedadCaracteristica()async{
    caracteristicasSeleccionadas.clear();
    enfermedadCaracteristica.clear();
    final url = '$_URL_BASE/relaciones/${enfermedadSeleccionada.id}';
    final resp = await http.get(Uri.parse(url));
    final items = Relaciones.fromJson(resp.body);
    caracteristicasSeleccionadas.addAll( items.relaciones );
    
    for (var global in caracteristicas ) {  
      for (var local in caracteristicasSeleccionadas) {
        if(global.id == local.idCaracteristica){
          enfermedadCaracteristica.add(global);
        }
      }
    }

    notifyListeners();
  }

  postRelaciones( int idE,int idC )async{
      final url = '$_URL_BASE/relaciones/';
      final resp = await http.post( Uri.parse(url), 
        body: jsonEncode({
          "idEnfermedad": idE,
          "idCaracteristica": idC
        }), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final nueva = Elemento.fromJson2( resp.body );
      relaciones.add( nueva );
      getEnfermedadCaracteristica();
      notifyListeners();
    }

  deleteRelaciones( int idE,int idC )async{
    final url = '$_URL_BASE/relaciones/';
    // ignore: unused_local_variable
    final resp = await http.delete( Uri.parse(url), 
      body: jsonEncode({
        "idEnfermedad": idE,
        "idCaracteristica": idC
      }), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );



    relaciones.removeWhere((element) => element.idCaracteristica == idC && element.idEnfermedad == idE);
    getEnfermedadCaracteristica();
    notifyListeners();
  }


  //Encapsulamiento

  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }


  //Cargar data
  void cargarData(){
    //List Relaciones idCarac idEnfer
    print("CARGAR DATA");

    for (final e in relaciones) {
      for (var enfer in enfermedades) {
        //Encontramos enfermedad
        //print("Enfermedad: " + enfer.nombre);
        if(enfer.id == e.idEnfermedad){
          //Limpiamos los sintomas
          for (var sintoma in caracteristicas) {
            if( e.idCaracteristica == sintoma.id ){
              //Cargamos a la enfermedad
              if(!enfer.sintomas.contains( sintoma )){
                print("Cargando data a enfermedades");
                enfer.sintomas.add( sintoma );
              }
            }
          }
        }
      }
      
    }
  }

  Future loadDataReset()async{
    await getAllEnfermedades();
    await getAllCaracteristicas();
    await getAllEnfermedadCaracteristica();
    cargarData();
    notifyListeners();
  }

  //TODO: Pensar en como resolver el pase de pregunta

  // String sitengoElsintoma( Caracteristica afirmacion ){
  //   sintomasSeleccionados.add( afirmacion );

  //   //Verifico las enfermedades que no tienen esta caracteristica
  //   for (var enfer in enfermedades) {
      
  //     //Si la enfermedad NOOO tiene este sintoma se quitan todos los que tenga
  //     if(!enfer.sintomas.contains( afirmacion )){
  //       final sin = enfer.sintomas;
  //       for( var s in sin ){
  //         caracteristicas.removeWhere((element) => s.nombre == element.nombre);
  //       }
  //     }
  //   }

  //   bool notEvaluation = false;
  //   String res = "";
  //   int contador = caracteristicas.length;
  //   int indice = 0;
  //   do{

  //     if( caracteristicas.contains(sintomasSeleccionados[indice]) && (indice+1) <= contador ){
  //       indice++;
  //     }else if(  ){

  //     }
  //   }while( notEvaluation != true );



  // }


  // void notengoElsitoma(){

  // }


  Caracteristica respuesta(bool res, Caracteristica? sin ){

    if( res == true && sin!=null){   
      sintomasSeleccionados.add(sin);
      for(var enf in enfermedades){
        if(!enf.sintomas.contains( sin )){
          for(var s in enf.sintomas){
            caracteristicas.removeWhere((element) => element.nombre == s.nombre);
          }
        }
      }
    }

    bool b = false;
    int c = 0;
    while( b == false && c<=caracteristicas.length){
      if(!sintomasSeleccionados.contains(caracteristicas[c])){
        b =true;
      }
      c++;
    }
    if( b == false){
      //diagnosticamos
      return Caracteristica(nombre: "encontrada");
    }
    //lo que se mostrara
    return caracteristicas[c];
      
    }
  
  
}