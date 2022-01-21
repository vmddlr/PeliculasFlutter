class Peliculas {
  List<Pelicula> items = [];

  Peliculas();

  Peliculas.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final pelicula = Pelicula.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

class Pelicula {
  late String unikeId;

  late int voteCount;
  late int id;
  late bool video;
  late double voteAverage;
  late String title;
  late double popularity;
  late String posterPath;
  late String originalLanguage;
  late String originalTitle;
  late List<int> genreIds;
  late String backdropPath;
  late bool adult = false;
  late String overview;
  late String releaseDate;

  Pelicula(
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  );

  Pelicula.fromJsonMap(Map<String, dynamic> json) {
    voteCount = json['vote_count'];

    id = json['id'];
    video = json['video'];
    voteAverage = json['vote_average'] / 1;
    title = json['title'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  getPosterImg() {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    } else {
      return 'https://www.bellavista.cl/static/assets/images/without_image.jpg';
    }
  }

  getBackgroundImg() {
    if (posterPath != null) {
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
    } else {
      return 'https://www.bellavista.cl/static/assets/images/without_image.jpg';
    }
  }
}
