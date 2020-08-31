import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:productosgmdpto/src/preferencias_usuarios/preferencia_usuarios.dart';

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyCb1isBaJLuYdHSSdLHEw8k39ser-_k9RY';

  final _prefs = new PreferenciasUsuario();

  // https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
  // https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
  // https://stark-crag-88093.herokuapp.com/login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {'email': email, 'password': password};

    final resp = await http.post('https://stark-crag-88093.herokuapp.com/login',
        body: {'email': email, 'password': '123456'});

    Map<String, dynamic> decodedResp = json.decode(resp.body);
//   body: json.encode(authData));
    print("*********************************** aqui*********************");
    print(authData);

    print(decodedResp);

    print("*********************************** aqui*********************");

    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      return {'ok': true, 'token': decodedResp['token']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
        body: json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodedResp['error']['message']};
    }
  }
}
