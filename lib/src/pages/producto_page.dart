import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productosgmd/src/bloc/proveedor.dart';
import 'package:productosgmd/src/models/producto_model.dart';
// import 'package:productosgmd/src/servicios/productos_provierder.dart';
import 'package:productosgmd/src/utils/utilis.dart' as utils;

class ProductoPag extends StatefulWidget {
  @override
  _ProductoPagState createState() => _ProductoPagState();
}

class _ProductoPagState extends State<ProductoPag> {
  final formularioKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final productoProvider = new ProductosProvider();

  // propiedades de mi clases
  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _salvando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    productosBloc = Proveedor.productosBloc(context);

    final ProductoModel productoData =
        ModalRoute.of(context).settings.arguments;
    if (productoData != null) {
      producto = productoData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Productos GMD'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formularioKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearCodigo(),
                _crearNombre(),
                _crearUnidaM(),
                _crearPrecioD(),
                _crearPrecioBs(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearCodigo() {
    return TextFormField(
      initialValue: producto.codigo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Codigo del Producto',
      ),
      // solo se lanza despues de validar los datos con validator
      onSaved: (value) => producto.codigo = value,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese el codigo del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearUnidaM() {
    return TextFormField(
      initialValue: producto.unidadm,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Unidad del Producto',
      ),
      onSaved: (value) => producto.unidadm = value,
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Nombre del Producto',
      ),
      onSaved: (value) => producto.nombre = value,
      validator: (value) {
        if (value.length < 2) {
          return 'Ingrese el Nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecioD() {
    return TextFormField(
      initialValue: producto.precioDolares.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      //keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio Dolares',
      ),
      onSaved: (value) => producto.precioDolares = double.parse(value),
      validator: (value) {
        if (utils.esUnNumero(value)) {
          return null;
        } else {
          return 'Ingrese Valor Numericos';
        }
      },
    );
  }

  Widget _crearPrecioBs() {
    return TextFormField(
      initialValue: producto.precioBss.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      //keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio Bss',
      ),
      onSaved: (value) => producto.precioBss = double.parse(value),
      validator: (value) {
        if (utils.esUnNumero(value)) {
          return null;
        } else {
          return 'Ingrese Valor Numericos';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.amber,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.00),
      ),
      color: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: (_salvando) ? null : _controlDelBotonOsubmit,
      icon: Icon(Icons.save),
      label: Text('Grabar'),
    );
  }

  // boton submit
  void _controlDelBotonOsubmit() async {
    if (!formularioKey.currentState.validate()) return;

    //if(formularioKey.currentState.validate())
    // cuando el formulario es valido

    // esto lo hago despues de validar

    formularioKey.currentState.save();

    setState(() {
      _salvando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      print(
          "*******************************-- Agregar -- ************************");
      productosBloc.agregarProductos(producto);
    } else {
      print(
          "*******************************-- editar -- ************************");
      print(productosBloc);
      print(producto.id);
      print(producto.precioBss);
      productosBloc.editarProductos(producto);
      print(
          "*******************************-fin--- editar -- ************************");
    }

    // setState(() { _salvando = false; });
    mostrarSnackbar('Regitro Guardado!');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 2500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/cargando.gif'),
        image: NetworkImage(producto.fotoUrl),
        height: 185.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 185,
        );
      }

      return Image(
        image: AssetImage('assets/no-img.png'),
        height: 185.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {
      // limpiar para evitar problemas
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
