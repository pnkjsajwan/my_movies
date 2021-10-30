final String tableMovies = 'movies';

class MovieDetails {
  static final List<String> values = [
    /// Add all fields
    id, name, director, moviePoster
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String director = 'director';
  static final String moviePoster = 'moviePoster';
}

class Movie {
  final int? id;
  final String name;
  final String director;
  final String moviePoster;

  Movie(
      {this.id,
      required this.name,
      required this.director,
      required this.moviePoster});

  Movie copy({
    int? id,
    String? name,
    String? director,
    String? moviePoster,
  }) =>
      Movie(
        id: id ?? this.id,
        name: name ?? this.name,
        director: director ?? this.director,
        moviePoster: moviePoster ?? this.moviePoster,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
        id: json[MovieDetails.id] as int,
        name: json[MovieDetails.name] as String,
        director: json[MovieDetails.director] as String,
        moviePoster: json[MovieDetails.moviePoster] as String,
      );

  Map<String, Object?> toJson() => {
        MovieDetails.id: id,
        MovieDetails.name: name,
        MovieDetails.director: director,
        MovieDetails.moviePoster: moviePoster,
      };
}
