import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommendation_app/core/widgets/primary_button.dart';

void main() {
  testWidgets(
      'Given primary button When loading is true Then find progress indicator',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: PrimaryButton(
      isLoading: true,
      onPressed: () {},
      text: "button",
    )));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'Given primary button When loading is false Then finds no progress indicator',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: PrimaryButton(
      isLoading: false,
      onPressed: () {},
      text: "button",
    )));
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('button'), findsOneWidget);
  });
}
