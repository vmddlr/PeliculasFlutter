import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/pelicula_model.dart';

class CardSwipeWidget extends StatelessWidget {
  final List<Pelicula> peliculas;

  const CardSwipeWidget({Key? key, required this.peliculas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {

          peliculas[index].unikeId = "${peliculas[index].id}-cards";

          return Hero(
            tag: peliculas[index].unikeId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detalle',
                    arguments: peliculas[index]),
                child: FadeInImage(
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  placeholder: const AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
