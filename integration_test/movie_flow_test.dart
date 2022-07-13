import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_recommendation_app/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendation_app/main.dart';
import 'stubs/stub_movie_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
      'test basic flow but make sure we do not get past the genre screen if we do not select a genre',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(StubMovieRepository())
        ],
        child: MyApp(),
      ),
    );

    // click the first button to go to genre screen
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // find the button to go to rating screen without selecting a genre
    await tester.tap(find.byType(PrimaryButton));

    // check that we are still on the genre screen
    expect(find.text('Action'), findsOneWidget);
  });

  testWidgets('test basic flow and see the fake generated movie in the end',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          movieRepositoryProvider.overrideWithValue(StubMovieRepository())
        ],
        child: MyApp(),
      ),
    );

    // click the first button to go to genre screen
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // find the action genre and click it
    await tester.tap(find.text('Action'));

    // find the button to go to rating screen
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // find the button to go to years back screen
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // find the button to go to movie screen
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();

    // find the movie title
    expect(find.text('Movie Title'), findsOneWidget);
  });
}
