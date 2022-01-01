import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_experto_flutter/src/models/caracteristicas_model.dart';
import 'package:sistema_experto_flutter/src/services/api_service.dart';

class ListTileCheck extends StatefulWidget {
  

  final Caracteristica caracteristica;
  const ListTileCheck({Key? key, required this.caracteristica}) : super(key: key);

  @override
  State<ListTileCheck> createState() => _ListTileCheckState();
}

class _ListTileCheckState extends State<ListTileCheck> {
  @override
  Widget build(BuildContext context) {

    final apiService = Provider.of<ApiService>(context);
    final controller = TextEditingController();
    controller.text = widget.caracteristica.nombre;

    return ListTile(
        title: widget.caracteristica.editing 
        ? SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Introduce el nuevo nombre',
                  ),
                ),
              )
            ],
          ),
        ) 
        :Text(widget.caracteristica.nombre.toUpperCase()),
      leading: CircleAvatar(child: Text('${widget.caracteristica.id}', style: const TextStyle(color: Colors.white),), backgroundColor: Colors.deepOrange,),
      trailing: SizedBox(
        width: 150,
        child: Row(
          children: [
            
            IconButton(
              onPressed: (){    
                setState(() {
                  widget.caracteristica.editing = !widget.caracteristica.editing;
                  //print( '${widget.caracteristica.editing}');
                });
              }, 
              icon: widget.caracteristica.editing ? const Icon(Icons.cancel) :const Icon(Icons.edit),
              splashRadius: 20,
            ),

            IconButton(
              onPressed: () async{
                print("Actualizar sintoma"+ controller.text);
                //TODO: Actualizar sintoma
                
                String resp = await apiService.putSintoma(widget.caracteristica.id!, controller.text.toString());

                if( resp.contains("msg")){
                  showDialog(context: context, builder: (context){
                    return const AlertDialog(
                      title: Text('El nombre ya existe'),
                    );
                  });
                }
              }, 
              icon: widget.caracteristica.editing ? const Icon(Icons.check_circle) : Container(),
              splashRadius: 20,
            ),

            widget.caracteristica.editing 
            ? IconButton(
              onPressed: (){
                print('Borrando sintoma');
                apiService.deleteSintoma( widget.caracteristica.id! );
              }, 
              icon: const Icon(Icons.delete_forever),
              splashRadius: 20,
            )
            :
            Checkbox(
              value: apiService.enfermedadCaracteristica.contains(widget.caracteristica),
              onChanged: ( value ){
                
                value == true 
                ? apiService.postRelaciones(apiService.enfermedadSeleccionada.id!, widget.caracteristica.id!)
                : apiService.deleteRelaciones(apiService.enfermedadSeleccionada.id!, widget.caracteristica.id!);
                
              },
            ),
          ],
        ),
      ),
    );
  
  }
}