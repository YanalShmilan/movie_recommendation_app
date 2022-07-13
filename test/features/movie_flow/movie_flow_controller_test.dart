import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_service.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:riverpod/riverpod.dart';

class MockMovieService extends Mock implements MovieService {}

void main() {
  late MovieService mockedMovieService;
  late ProviderContainer container;
  late Genre genre;

  setUp(() {
    mockedMovieService = MockMovieService();
    container = ProviderContainer(overrides: [
      movieServiceProvider.overrideWithValue(mockedMovieService),
    ]);
    genre = const Genre(id: 28, name: 'Action');
    when(() => mockedMovieService.getGenres())
        .thenAnswer((_) => Future.value(Success([genre])));
  });

  tearDown(() {
    container.dispose();
  });

  group('MovieFlowControllerTests -', () {
    test('Given genres When Toggle Then that genre should be toggled',
        () async {
      await container
          .read(movieFlowControllerProvider.notifier)
          .stream
          .firstWhere((state) => state.genres is AsyncData);
      container
          .read(movieFlowControllerProvider.notifier)
          .toggleSelected(genre);
      final toggledGenre = genre.toggleSelected();
      expect(container.read(movieFlowControllerProvider).genres.value,
          [toggledGenre]);
    });

    for (final rating in [1, 2, 3, -4, 5]) {
      test('Given rating $rating When setRating Then that rating should be set',
          () {
        container
            .read(movieFlowControllerProvider.notifier)
            .updateRating(rating);
        expect(container.read(movieFlowControllerProvider).rating,
            rating < 0 ? 0 : rating);
      });
    }

    for (final yearsBack in [1, 2, 3, -4, 5]) {
      test(
          'Given yearsBack $yearsBack When setYearsBack Then that yearsBack should be set',
          () {
        container
            .read(movieFlowControllerProvider.notifier)
            .updateYearsBack(yearsBack);
        expect(container.read(movieFlowControllerProvider).yearsBack,
            yearsBack < 0 ? 0 : yearsBack);
      });
    }
  });
}
