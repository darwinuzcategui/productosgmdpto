import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:productosgmd/src/bloc/validadores.dart';


class LoginBloc with Validadores {

  /* cuando se utiliza rxjdart no tine StreamController
  final _emailController = StreamController<String>.broadcast();
  final _claveController = StreamController<String>.broadcast();
  */
  final _emailController = BehaviorSubject<String>();
  final _claveController = BehaviorSubject<String>();

  
 // Getter ********

 // Recuperar los datos del Stream ( escuchando)
 Stream<String> get claveStream => _claveController.stream.transform(validarClave);
 Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
    
  
 Stream<bool> get formularioValidarStream => 
        CombineLatestStream.combine2(emailStream,claveStream, (e, p) => true);
      



  // Insertar valores al Stream
  Function (String) get cambioEmail => _emailController.sink.add;
  Function (String) get cambioClave => _claveController.sink.add;

  // obtner el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get clave => _claveController.value; 
  
  
  dispose(){
    _claveController?.close();
    _emailController?.close();
  }

} 

