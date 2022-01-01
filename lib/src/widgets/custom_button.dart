import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  
  final String titulo;
  final Function() onPressed;
  double ?ancho = 150;
  double ?alto = 50;
  MaterialColor? color = Colors.blue;

  CustomButton({Key? key, required this.titulo, required this.onPressed, this.alto, this.ancho, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
          child: Container(
            width: ancho,
            height: alto,
            child:  Center(child: Text(titulo, style:const TextStyle(fontSize: 18, color: Colors.white),)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
            )
          ),
          onPressed: onPressed,
    );
  }
}