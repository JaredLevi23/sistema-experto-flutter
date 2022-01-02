import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';
import 'package:sistema_experto_flutter/src/models/enfermedad_model.dart';

class TestController{


  TestController();

  List<Enfermedad> diagnostico( List<Enfermedad> enfermedades,List<Caracteristica> sintomas,List<Caracteristica> nosintomas  ){
    //Conteo de sintomas en enfermedad

    for (final enfermedad in enfermedades) {
      enfermedad.conteo = 0;

      for (final nosin in nosintomas) {
        if(enfermedad.sintomas.contains( nosin )){
          enfermedad.estado = false;
        }
      }

      for( final sintoma in sintomas ){
        if( enfermedad.sintomas.contains( sintoma )){
          enfermedad.conteo++;    
          for (var element in enfermedad.sintomas) { 
            if( element.nombre == sintoma.nombre){
              element.bandera = true;
            }
          }
        }
      }
    }

    // Enfermedad diagnosticada = enfermedades[0];
    // for(final e in enfermedades){
    //   if(e.conteo>= diagnosticada.conteo){
    //     diagnosticada = e;
    //   }
    // }
    //¿Quien tiene mas puntaje?
    return enfermedades;
  }

  
}