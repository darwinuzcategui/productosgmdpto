// este es archivo encargado de la interacion con nuestra basedatos

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:productosgmdpto/src/models/producto_model.dart';
import 'package:productosgmdpto/src/preferencias_usuarios/preferencia_usuarios.dart';

class ProductosProvider {
  final String _url = 'https://stark-crag-88093.herokuapp.com';
  final _prefs = new PreferenciasUsuario();

  //Incluir o crear productos
  Future<bool> crearProductoGMD(ProductoModel productogmd) async {
    final url = '$_url/productos';
    /*
    hJson[ "precioUni" ] := 55122.22
    hJson[ "grupo" ] := "5edd11f76c3b140017ee64e3"
    hJson[ "marca" ] := "5edd120d6c3b140017ee64e4"
    */

    final resp = await http.post(url,
        headers: {'token': _prefs.token},
        body: productoModelToJson(productogmd));
    //  productoModelToJson
    // productoModelFromJson

    print("------------------------------");
    print(productogmd.toJson());
    print("------------------------------");

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  // modificar o editar productos
  Future<bool> editarProductoGMD(ProductoModel productogmd) async {
    final url = '$_url/productos/${productogmd.id}';

    final resp = await http.put(url, headers: {
      'token': _prefs.token
    }, body: {
      'nombre': productogmd.nombre,
      'precioBss': productogmd.precioBss.toString(),
      'precioDolares': productogmd.precioDolares.toString(),
      'unidadm': productogmd.unidadm,
      'fotoUrl': productogmd.fotoUrl,
      'disponible': productogmd.disponible.toString()
    });

    final decodedData = json.decode(resp.body);

    print(decodedData);
    print(resp);

    return true;
  }

  // listado de productos desde ApiGMD
  Future<List<ProductoModel>> cargarProductosDesdeApiGMD() async {
    final url = '$_url/productos?limite=0&desde=0';

    final resp = await http.get(url, headers: {'token': _prefs.token});

    final Map<String, dynamic> decodificaData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    // print("****************datos de productos************");

    // print(decodificaData['productos']);

    // print("****************final datos de productos************");
    if (decodificaData == null) return [];

    if (decodificaData['error'] != null) return [];

    decodificaData['productos'].forEach((listaproductos) {
      final prodTemp = ProductoModel.fromJson(listaproductos);

      productos.add(prodTemp);
      print("-----------------************************-----------------------");
      print(prodTemp);
      print(prodTemp.nombre);
      print("----------------*********fin***************");
    });

    return productos;
  }

  // crear el metodo para borrar ApiGMD

  Future<int> borrarProductoDeApiGMD(String id) async {
    final url = '$_url/productos/$id';

    final resp = await http.delete(url, headers: {'token': _prefs.token});

    print(resp.body);

    return 1;
  }

  //servicio de subir imagen

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'http://api.cloudinary.com/v1_1/personaldarwin/image/upload?upload_preset=uhdzlcgv');
    final mineType =
        mime(imagen.path).split('/'); //para separar //imagen/tipo jpeg

    final imageSubirReq = http.MultipartRequest('POST', url);

    print(mineType);
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mineType[0], mineType[1]));

    imageSubirReq.files.add(file);

    final streamedResponse = await imageSubirReq.send();

    final resp = await http.Response.fromStream(streamedResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo Salio Mal !');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData);

    return respData['secure_url'];
  }

  // buscar
  // listado de productos desde ApiGMD

  Future<List<ProductoModel>> buscarProductos(String termino) async {
    final url = '$_url/productos/buscar/$termino';

    final resp = await http.get(url, headers: {'token': _prefs.token});

    final Map<String, dynamic> decodificaData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    // print("****************datos de productos************");

    // print(decodificaData['productos']);

    // print("****************final datos de productos************");
    if (decodificaData == null) return [];

    if (decodificaData['error'] != null) return [];

    decodificaData['producto'].forEach((listaproductos) {
      final prodTemp = ProductoModel.fromJson(listaproductos);

      productos.add(prodTemp);
      print("-----------------************************-----------------------");
      print(prodTemp);
      print(prodTemp.nombre);
      print("----------------*********fin***************");
    });

    return productos;
  }
}
