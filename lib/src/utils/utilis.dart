

import 'package:flutter/material.dart';

bool esUnNumero(String valor) {

  if (valor.isEmpty) return false;
  // determino si se puede parser
  final numero = num.tryParse(valor);
  return (numero == null ) ? false : true;

}

void mostratAlerta(BuildContext context,String mensaje ) {
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Informacion incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(onPressed: ()=>Navigator.of(context).pop(), 
          child: Text('ok'),
          ),
        ],
      );
    }
    );

}