import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';

class CardSwipeHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  CardSwipeHorizontal({
    Key? key,
    required this.peliculas,
    required this.siguientePagina
  }) : super(key: key);

  final _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * .25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);
        },
        // children: _tarjetas(context),
      ),
    );
  }

  _tarjeta(BuildContext context, Pelicula pelicula){
    pelicula.unikeId = "${pelicula.id}-footers";

    final tareta = Container(
      margin: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          Hero(
            tag: pelicula.unikeId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
      child: tareta,
    );
  }
}
