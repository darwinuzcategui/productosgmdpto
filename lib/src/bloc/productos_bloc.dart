import 'dart:io';

import 'package:rxdart/rxdart.dart';

import 'package:productosgmd/src/servicios/productos_provierder.dart';
import 'package:productosgmd/src/models/producto_model.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productoProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async {
    final productos = await _productoProvider.cargarProductosDesdeApiGMD();

    _productosController.sink.add(productos);
    print(
        "******************************-------------Ejecuto cargar productos");
    print("Ejecuto cargar productos");
  }

  void agregarProductos(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productoProvider.crearProductoGMD(producto);
    _cargandoController.sink.add(false);
    // esta linea de prueba
    cargarProductos();
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _productoProvider.subirImagen(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  void editarProductos(ProductoModel producto) async {
    _cargandoController.sink.add(true);
    await _productoProvider.editarProductoGMD(producto);
    _cargandoController.sink.add(false);
  }

  void eliminarProductos(String id) async {
    await _productoProvider.borrarProductoDeApiGMD(id);
  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }
}
