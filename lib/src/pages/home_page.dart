import 'package:flutter/material.dart';
import 'package:productosgmdpto/src/bloc/proveedor.dart';
import 'package:productosgmdpto/src/buscar/buscar_clase_delegada.dart';
import 'package:productosgmdpto/src/models/producto_model.dart';

class HomePage extends StatelessWidget {
  // final productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Proveedor.of(context);
    final productoBloc = Proveedor.productosBloc(context);
    productoBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos GMD'),
        // backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BuscarDatos(),
                  // query: 'Hola'
                );
              },
            )
          ],
       ),
      body: _creaListadoProductosGMD(productoBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _creaListadoProductosGMD(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productosGMD = snapshot.data;

          return ListView.builder(
            itemCount: productosGMD.length,
            itemBuilder: (context, indice) => _crearItemProductosGMD(
                context, productosBloc, productosGMD[indice]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItemProductosGMD(BuildContext context,
      ProductosBloc productosBloc, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        /*
        onDismissed: (direccion) {
          productoProvider.borrarProductoDeFirebase(producto.id);
         
        },
        */
        onDismissed: (direccion) =>
            productosBloc.eliminarProductos(producto.id),
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-img.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/cargando.gif'),
                      image: NetworkImage(producto.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.codigo} - ${producto.nombre} '),
                subtitle: Text(
                    'Precios ${producto.precioDolares} Bss ${producto.precioBss}'),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    final productoBloc = Proveedor.productosBloc(context);
    productoBloc.cargarProductos();
    return FloatingActionButton(
      child: Icon(Icons.assistant),
      backgroundColor: Colors.orangeAccent,
      // _creaListadoProductosGMD(productoBloc),
      onPressed: () => (productoBloc.cargarProductos()),
      //  onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }
}
