import 'package:movie_recommendation_app/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie_entity.dart';

class StubMovieRepository implements MovieRepository {
  @override
  Future<List<GenreEntity>> getMovieGenres() async {
    return Future.value(const [GenreEntity(id: 28, name: 'Action')]);
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovies(
      double rating, String genreId, String yearsBack) async {
    return Future.value([
      const MovieEntity(
        title: 'Movie Title',
        posterPath: 'IfB9hy4JH1eH6HEfIgIGORXi5h.jpg',
        backdropPath: 'IfB9hy4JH1eH6HEfIgIGORXi5h.jpg',
        voteAverage: "5.0",
        overview: 'overview',
        releaseDate: 'releaseDate',
        genreIds: [28],
      ),
    ]);
  }
}
