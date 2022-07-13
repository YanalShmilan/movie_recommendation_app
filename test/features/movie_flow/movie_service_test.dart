import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_recommendation_app/core/failure.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_service.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie_entity.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
  });

  test(
      'Given successful call When getting GenreEntities Then map to correct genres',
      () async {
    when(() => mockMovieRepository.getMovieGenres()).thenAnswer(
      (_) async => Future.value(
        [
          const GenreEntity(id: 28, name: 'Action'),
        ],
      ),
    );
    final movieService = TMDBMovieService(mockMovieRepository);
    final result = await movieService.getGenres();

    expect(result.getSuccess(), [const Genre(id: 28, name: 'Action')]);
  });

  test('Given failed call When getting GenreEntities Then return failure',
      () async {
    when(() => mockMovieRepository.getMovieGenres()).thenThrow(
        const Failure(message: "Error", exception: SocketException('')));
    final movieService = TMDBMovieService(mockMovieRepository);
    final result = await movieService.getGenres();
    expect(result.getError()?.exception, isA<SocketException>());
  });

  test(
      'Given successful call When getting MovieEntity Then map to correct Movie',
      () async {
    const genre = Genre(id: 28, name: 'Action', isSelected: true);
    const MovieEntity movieEntity = MovieEntity(
      title: 'Movie Title',
      posterPath: 'posterPath',
      backdropPath: 'backdropPath',
      voteAverage: "5.0",
      overview: 'overview',
      releaseDate: 'releaseDate',
      genreIds: [28],
    );
    when(() => mockMovieRepository.getRecommendedMovies(any(), any(), any()))
        .thenAnswer((_) {
      return Future.value([movieEntity]);
    });
    final movieService = TMDBMovieService(mockMovieRepository);
    final result =
        await movieService.getRecommendedMovie(2, 20, [genre], DateTime(2022));
    final movie = result.getSuccess();

    expect(
        movie,
        Movie(
          title: movieEntity.title,
          posterPath:
              'https://images.tmdb.org/t/p/original/${movieEntity.posterPath}',
          backdropPath:
              'https://images.tmdb.org/t/p/original/${movieEntity.backdropPath}',
          voteAverage: movieEntity.voteAverage,
          overview: movieEntity.overview,
          releaseDate: movieEntity.releaseDate,
          genres: const [genre],
        ));
  });

  test('Given failed call When getting MovieEntity Then return failure',
      () async {
    when(() => mockMovieRepository.getRecommendedMovies(any(), any(), any()))
        .thenThrow(
            const Failure(message: "Error", exception: SocketException('')));
    final movieService = TMDBMovieService(mockMovieRepository);
    final result =
        await movieService.getRecommendedMovie(2, 20, [], DateTime(2022));
    expect(result.getError()?.exception, isA<SocketException>());
  });
}
