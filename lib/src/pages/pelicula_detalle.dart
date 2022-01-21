import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class PeliculaDetallePage extends StatelessWidget {
  const PeliculaDetallePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula =
        ModalRoute.of(context)!.settings.arguments as Pelicula;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _crearAppBar(pelicula),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(
            height: 10.0,
          ),
          _posterTitulo(pelicula, context),
          _descripcionPelicula(pelicula),
          _descripcionPelicula(pelicula),
          _descripcionPelicula(pelicula),
          _descripcionPelicula(pelicula),
          _crearCasting(pelicula),
        ]))
      ],
    ));
  }

  _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              backgroundColor: Colors.black45),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: const AssetImage('assets/img/loading.gif'),
          fadeInDuration: const Duration(milliseconds: 150),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.unikeId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
          Flexible(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  pelicula.title,
                  style: Theme.of(context).textTheme.headline4,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(pelicula.originalTitle,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis),
                Row(children: [
                  const Icon(Icons.star_border),
                  Text(
                    pelicula.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subtitle2,
                  )
                ])
              ]))
        ],
      ),
    );
  }

  _descripcionPelicula(Pelicula pelicula) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  _crearCasting(Pelicula pelicula) {
    final peliProvider = PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPager(snapshot.data!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _crearActoresPager(List<Actor> actores) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: const AssetImage('assets/img/no-image.jpg'),
              image: NetworkImage(actor.getFoto()),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12.0),
          )
        ],
      ),
    );
  }
}
