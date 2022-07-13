import 'dart:math';

import 'package:movie_recommendation_app_course/core/failure.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/movie.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:riverpod/riverpod.dart';

abstract class MovieService {
  Future<Result<Failure, Movie>> getRecommendedMovie(
      int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFromDate]);
  Future<Result<Failure, List<Genre>>> getGenres();
}

final movieServiceProvider = Provider<MovieService>(
  (ref) {
    final movieRepository = ref.read(movieRepositoryProvider);
    return TMDBMovieService(movieRepository);
  },
);

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieRepository);
  final MovieRepository _movieRepository;
  @override
  Future<Result<Failure, Movie>> getRecommendedMovie(
      int rating, int yearsBack, List<Genre> genres,
      [DateTime? yearsBackFromDate]) async {
    final date = yearsBackFromDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((e) => e.id).toList().join(',');
    try {
      final moviesEntities = await _movieRepository.getRecommendedMovies(
          rating.toDouble(), '$year-01-01', genreIds);
      final movies =
          moviesEntities.map((e) => Movie.fromMovieEntity(e, genres)).toList();
      final rnd = Random();
      final randomMovie = movies[rnd.nextInt(movies.length)];
      if (movies.isEmpty) {
        return const Error(Failure(message: "No movie found"));
      }
      return Success(randomMovie);
    } on Failure catch (failure) {
      return Error(failure);
    }
  }

  @override
  Future<Result<Failure, List<Genre>>> getGenres() async {
    try {
      final genresEntities = await _movieRepository.getMovieGenres();
      return Success(genresEntities.map((e) => Genre.fromEntity(e)).toList());
    } on Failure catch (failure) {
      return Error(failure);
    }
  }
}
