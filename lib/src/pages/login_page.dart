import 'package:flutter/material.dart';
import 'package:productosgmdpto/src/bloc/proveedor.dart';
import 'package:productosgmdpto/src/servicios/usuarios_provierder.dart';
import 'package:productosgmdpto/src/utils/utilis.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Proveedor.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 140.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 8.0),
                    spreadRadius: 3.0,
                  )
                ]),
            child: Column(
              children: <Widget>[
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 50.0),
                _crearEmail(bloc),
                SizedBox(height: 25.0),
                _crearClave(bloc),
                SizedBox(height: 25.0),
                _crearBoton(bloc),
              ],
            ),
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'registro'),
              child: Text('Crear Una Nueva Cuenta')),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.amber),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo Electronico',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: (valor) => bloc.cambioEmail(valor),
            // onChanged: =>bloc.cambioEmail,
          ),
        );
      },
    );
  }

  _crearClave(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.claveStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            obscureText: true,
            // keyboardType:TextInputType.visiblePassword,

            decoration: InputDecoration(
              icon: Icon(Icons.security, color: Colors.amber),
              // hintText: '123456',
              labelText: 'Clave',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.cambioClave,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    // formularioValidarStream

    return StreamBuilder(
      stream: bloc.formularioValidarStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Container(
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0.0,
            color: Colors.amber,
            textColor: Colors.white,
            // onPressed: snapshot.hasData ?() {}:null
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    print('===========================');
    print('Email: ${bloc.email} ');
    print('Password: ${bloc.clave}');
    print('===========================');

    Map info = await usuarioProvider.login(bloc.email, bloc.clave);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'inicio');
    } else {
      mostratAlerta(context, info['mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoNaraja = Container(
      height: size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(255, 179, 0, 1.0),
        Color.fromRGBO(247, 220, 111, 1.0)
      ])),
    );

    final circulo = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.5),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoNaraja,
        Positioned(top: 60.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),

        Container(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(children: <Widget>[
            Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
            SizedBox(height: 10.0, width: double.infinity),
            Text('Gmd Pto Movil',
                style: TextStyle(color: Colors.white, fontSize: 25.0)),
          ]),
        )

        // circulos,
      ],
    );
  }
}
