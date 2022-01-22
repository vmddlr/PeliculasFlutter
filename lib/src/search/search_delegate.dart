import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculasProvider = PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'Acuaman',
    'Spiderman 2',
    'Liga de la justicia',
    'Guardianes de la galaxia',
    'Hulk',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Acciones de nuestro AppBar
    return [
      IconButton(
          onPressed: () =>
          {
            query = '',
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Icono de la izquierda
    return IconButton(
        onPressed: () => {close(context, null)},
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crear los resultados a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculasSnap = snapshot.data!;

          return ListView(
            children: peliculasSnap.map((peli) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage(peli.getPosterImg()),
                    placeholder: const AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                  title: Text(peli.title),
                  subtitle: Text(peli.originalTitle),
                  onTap: (){
                    close(context, null);
                    peli.unikeId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: peli);
                  },
                );
            }).toList()
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

// @override
// Widget buildSuggestions(BuildContext context) {
//   // Sugerencias cuando la persona escribe
//
//   final listaSugerida = (query.isEmpty)
//       ? peliculasRecientes
//       : peliculas
//       .where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();
//
//   return ListView.builder(
//     itemCount: listaSugerida.length,
//     itemBuilder: (BuildContext context, int index) {
//       return ListTile(
//         leading: const Icon(Icons.movie),
//         title: Text(listaSugerida[index]),
//         onTap: () {},
//       );
//     },
//   );
// }
}
