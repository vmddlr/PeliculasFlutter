import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';
import 'package:movies/src/widgets/card_swipe_horizontal_widget.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final provider = PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    provider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas de cine'),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: delegate)
                },
                icon: const Icon(Icons.search)
            )],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_swiperTarjetas(), _footerTarjetas(context)],
          ),
        ));
  }

  _swiperTarjetas() {
    return FutureBuilder(
        future: provider.getEnCine(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
          if (snapshot.hasData) {
            return CardSwipeWidget(peliculas: snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  _footerTarjetas(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1),
          ),
          const SizedBox(height: 10.0),
          StreamBuilder(
              stream: provider.popularesStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
                if (snapshot.hasData) {
                  return CardSwipeHorizontal(
                      peliculas: snapshot.data!,
                      siguientePagina: provider.getPopulares,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
