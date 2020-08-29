import 'package:flutter/material.dart';
import 'package:productosgmdpto/src/models/producto_model.dart';
import 'package:productosgmdpto/src/servicios/productos_provierder.dart';

class BuscarDatos extends SearchDelegate {
  String seleccion = '';
  final productosProvider = new ProductosProvider();

  final productos = [
    'Sistemas',
    'Nomina',
    'Facturacion',
    'Teclado',
    'Mouse',
    'Impresora Fiscal'
  ];

  final productosRecientes = ['Teclado', 'Impresora Fiscal'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // lass acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icno a la izqueirda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.yellow,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias qe aparcen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: productosProvider.buscarProductos(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          print("****************datos de productos************");

          return ListView(
            children: productos.map((productos) {
              return ListTile(
                leading: FadeInImage(

                    //placeholder: AssetImage('assets/cargando.gif'),
                    //    image: NetworkImage(producto.fotoUrl),
                    //
                    image: NetworkImage((productos.fotoUrl != null)
                        ? productos.fotoUrl
                        : "http://sociedadedepsicanalise.com.br/blog/wp-content/uploads/no-thumbnail.jpg"),
                    placeholder: AssetImage('assets/cargando.gif'),
                    width: 50.0,
                    fit: BoxFit.contain),
                title: Text(productos.nombre),
                // subtitle: Text(productos.codigo),
                subtitle: Text(productos.precioDolares.toString()),
                onTap: () {
                  close(context, null);
                  productos.id = '';
                  Navigator.pushNamed(context, 'producto',
                      arguments: productos);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // son las sugerencias qe aparcen cuando la persona escribe

  //   final listaSugeridas = ( query.isEmpty )
  //                           ? peliculasRecientes
  //                           : peliculas.where(
  //                             (p) => p.toLowerCase().startsWith(query.toLowerCase())
  //                           ).toList();

  //   return ListView.builder(
  //     itemCount: listaSugeridas.length,
  //     itemBuilder: ( context, i ) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaSugeridas[i]),
  //         onTap: () {
  //           seleccion = listaSugeridas[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   ) ;
  // }

}
