import 'dart:io';
import 'package:dio/dio.dart';
import 'package:movie_recommendation_app/core/environment_variables.dart';
import 'package:movie_recommendation_app/core/failure.dart';
import 'package:riverpod/riverpod.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie_entity.dart';
import 'package:movie_recommendation_app/main.dart';

abstract class MovieRepository {
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genreIds);
  Future<List<GenreEntity>> getMovieGenres();
}

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) {
    final dio = ref.read(dioProvider);
    return TMDBMovieRepository(dio);
  },
);

class TMDBMovieRepository implements MovieRepository {
  final Dio dio;

  TMDBMovieRepository(this.dio);

  @override
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String date, String genreIds) async {
    try {
      final response = await dio.get('/discover/movie', queryParameters: {
        'api_key': api,
        'language': 'en-US',
        'sort_by': 'popularity.desc',
        'include_adult': 'false',
        'include_video': 'false',
        'page': '1',
        'with_genres': genreIds,
        'primary_release_date.gte': date,
        'vote_average.gte': rating,
      });
      final results = List<Map<String, dynamic>>.from(response.data['results']);
      return results.map((e) => MovieEntity.fromMap(e)).toList();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(
          message: 'No internet connection',
          exception: e.error,
        );
      }
      throw Failure(
        message: e.response?.statusMessage ?? 'Something went wrong',
        code: e.response?.statusCode,
        exception: e,
      );
    }
  }

  @override
  Future<List<GenreEntity>> getMovieGenres() async {
    try {
      final response = await dio.get('/genre/movie/list',
          queryParameters: {'api_key': api, 'language': 'en-US'});
      return (response.data['genres'] as List)
          .map((e) => GenreEntity.fromMap(e))
          .toList();
    } on DioError catch (e) {
      if (e.error is SocketException) {
        throw Failure(
          message: 'No internet connection',
          exception: e.error,
        );
      }
      throw Failure(
        message: e.response?.statusMessage ?? 'Something went wrong',
        code: e.response?.statusCode,
        exception: e,
      );
    }
  }
}
