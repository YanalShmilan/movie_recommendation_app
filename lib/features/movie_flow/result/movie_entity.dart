import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable

class MovieEntity {
  final String title;
  final String overview;
  final String voteAverage;
  final String releaseDate;
  final String? posterPath;
  final String? backdropPath;
  final List<int> genreIds;
  const MovieEntity({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    this.posterPath,
    this.backdropPath,
    required this.genreIds,
  });

  MovieEntity copyWith({
    String? title,
    String? overview,
    String? voteAverage,
    String? releaseDate,
    String? posterPath,
    String? backdropPath,
    List<int>? genreIds,
  }) {
    return MovieEntity(
      title: title ?? this.title,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      genreIds: genreIds ?? this.genreIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'genreIds': genreIds,
    };
  }

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      voteAverage: map['vote_average'].toString(),
      releaseDate: map['release_date'] ?? '',
      posterPath: map['poster_path'],
      backdropPath: map['backdrop_path'],
      genreIds: List<int>.from(map['genre_ids']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieEntity.fromJson(String source) => MovieEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MovieEntity(title: $title, overview: $overview, voteAverage: $voteAverage, releaseDate: $releaseDate, posterPath: $posterPath, backdropPath: $backdropPath, genreIds: $genreIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MovieEntity &&
      other.title == title &&
      other.overview == overview &&
      other.voteAverage == voteAverage &&
      other.releaseDate == releaseDate &&
      other.posterPath == posterPath &&
      other.backdropPath == backdropPath &&
      listEquals(other.genreIds, genreIds);
  }

  @override
  int get hashCode {
    return title.hashCode ^
      overview.hashCode ^
      voteAverage.hashCode ^
      releaseDate.hashCode ^
      posterPath.hashCode ^
      backdropPath.hashCode ^
      genreIds.hashCode;
  }
}
