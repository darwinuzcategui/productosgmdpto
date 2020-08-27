import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:productosgmdpto/src/bloc/login_bloc.dart';
export 'package:productosgmdpto/src/bloc/login_bloc.dart';

import 'package:productosgmdpto/src/bloc/productos_bloc.dart';
export 'package:productosgmdpto/src/bloc/productos_bloc.dart';

class Proveedor extends InheritedWidget {

  final loginBloc      = new LoginBloc();
  final _productosBloc = new ProductosBloc();


  static Proveedor _instaciaActualDeLaClase;
  // ahora voy crear factory
  // la idea del factory;es que determinar si tiene que regresar la instancia actual existente
  // o crear una nueva instancia de la clases

  factory Proveedor({Key key, Widget child}) {

    if(_instaciaActualDeLaClase == null){
      // aqui hacemos un contructor privado para evitar que se instacie la clase desde afuera de la class
      _instaciaActualDeLaClase = new Proveedor._internal(key: key , child: child);

    }

    return _instaciaActualDeLaClase;


  }

  Proveedor._internal({Key key, Widget child})
    :super(key: key, child: child);


  

 // Proveedor({Key key, Widget child})
 //   :super(key: key, child: child);

    
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Proveedor>().loginBloc;
  }

  
   static ProductosBloc productosBloc ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Proveedor>()._productosBloc;
  
   }
 
}