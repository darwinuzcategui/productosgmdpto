import 'package:flutter/material.dart';
import 'package:productosgmdpto/src/bloc/proveedor.dart';
import 'package:productosgmdpto/src/pages/home_page.dart';
import 'package:productosgmdpto/src/pages/login_page.dart';
import 'package:productosgmdpto/src/pages/producto_page.dart';
import 'package:productosgmdpto/src/pages/registro_pag.dart';
import 'package:productosgmdpto/src/preferencias_usuarios/preferencia_usuarios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext _context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Proveedor(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Formulario Validacion',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'inicio': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => ProductoPag(),
        },
        theme: ThemeData(primaryColor: Colors.orange),
      ),
    );
  }
}
