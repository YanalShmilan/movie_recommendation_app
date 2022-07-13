
import 'package:flutter/foundation.dart';

import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie_entity.dart';

@immutable
class Movie {
  final String title;
  final String overview;
  final String voteAverage;
  final String releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final List<Genre> genres;
  const Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
     this.posterPath,
     this.backdropPath,
    required this.genres,
  });


  Movie copyWith({
    String? title,
    String? overview,
    String? voteAverage,
    String? releaseDate,
    String? posterPath,
    String? backdropPath,
    List<Genre>? genres,
  }) {
    return Movie(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      genres: genres ?? this.genres,
    );
  }

  factory Movie.fromMovieEntity(MovieEntity entity,List<Genre> genres) {
    return Movie(
      title: entity.title,
      overview: entity.overview,
      voteAverage: entity.voteAverage,
      releaseDate: entity.releaseDate,
      posterPath: "https://images.tmdb.org/t/p/original/${entity.posterPath}",
      backdropPath: "https://images.tmdb.org/t/p/original/${entity.backdropPath}",
      genres: genres.where((genre) => entity.genreIds.contains(genre.id)).toList(growable: false),
    );
  }

  String get genresCommaSeparated {
    return genres.map((genre) => genre.name).join(', ');
  }

  


  @override
  String toString() {
    return 'Movie(title: $title, overview: $overview, voteAverage: $voteAverage, releaseDate: $releaseDate, posterPath: $posterPath, backdropPath: $backdropPath, genres: $genres)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Movie &&
      other.title == title &&
      other.overview == overview &&
      other.voteAverage == voteAverage &&
      other.releaseDate == releaseDate &&
      other.posterPath == posterPath &&
      other.backdropPath == backdropPath &&
      listEquals(other.genres, genres);
  }

  @override
  int get hashCode {
    return title.hashCode ^
      overview.hashCode ^
      voteAverage.hashCode ^
      releaseDate.hashCode ^
      posterPath.hashCode ^
      backdropPath.hashCode ^
      genres.hashCode;
  }
}
