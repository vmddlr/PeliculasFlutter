import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies/src/models/actores_model.dart';
import 'package:movies/src/models/pelicula_model.dart';

class PeliculasProvider {
  final String _apiKey = 'd5b85f76495001d2e67853435ecd46c8';
  final String _url = 'api.themoviedb.org';
  final String _language = 'es-ES';

  int _pagina = 0;
  bool _peticionHttp = false;

  final List<Pelicula> _populares = [];
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  disposeStream() {
    _popularesStreamController.close();
  }

  Future<List<Pelicula>> _getList(Uri url) async {
    final resp = await http.get(url);
    final decode = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decode['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCine() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});

    return await _getList(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_peticionHttp) return [];

    _peticionHttp = true;
    _pagina++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _pagina.toString()
    });

    final resp = await _getList(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _peticionHttp = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final cast = Cast.fromJsonList(decodeData['cast']);
    return cast.actores;
  }
}
