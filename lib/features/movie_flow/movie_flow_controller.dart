import 'package:flutter/cupertino.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_flow_state.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_service.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie.dart';
import 'package:riverpod/riverpod.dart';

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this._movieService) : super(state) {
    loadGenres();
  }

  Future<void> loadGenres() async {
    state = state.copyWith(genres: const AsyncValue.loading());
    final result = await _movieService.getGenres();

    result.when((error) {
      state = state.copyWith(genres: AsyncValue.error(error));
    }, (genres) {
      state = state.copyWith(genres: AsyncValue.data(genres));
    });
  }

  Future<void> getRecommendedMovie() async {
    state = state.copyWith(movie: const AsyncValue.loading());
    final result = await _movieService.getRecommendedMovie(
      state.rating,
      state.yearsBack,
      state.genres.value?.where((e) => e.isSelected).toList(growable: false) ??
          [],
    );
    result.when((error) {
      state = state.copyWith(movie: AsyncValue.error(error));
    }, (movie) {
      state = state.copyWith(movie: AsyncValue.data(movie));
    });
  }

  final MovieService _movieService;
  void toggleSelected(Genre genre) {
    state = state.copyWith(
        genres: AsyncValue.data([
      for (final g in state.genres.value!)
        if (g == genre) g.toggleSelected() else g,
    ]));
  }

  void updateRating(int updateRating) {
    state = state.copyWith(
      rating: updateRating < 0 ? 0 : updateRating,
    );
  }

  void updateYearsBack(int updateYearsBack) {
    state = state.copyWith(
      yearsBack: updateYearsBack < 0 ? 0 : updateYearsBack,
    );
  }

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!state.genres.value!.any((g) => g.isSelected)) {
        return;
      }
    }
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  void previousPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }
}

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
  (ref) => MovieFlowController(
      MovieFlowState(
        pageController: PageController(),
        movie: const AsyncValue.data(Movie(
          title: '',
          posterPath: '',
          overview: '',
          releaseDate: '',
          voteAverage: '0',
          genres: [],
        )),
        genres: const AsyncValue.data([]),
      ),
      ref.watch(movieServiceProvider)),
);
