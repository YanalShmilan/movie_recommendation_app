import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app/core/constants.dart';
import 'package:movie_recommendation_app/core/failure.dart';
import 'package:movie_recommendation_app/core/widgets/failure_body.dart';
import 'package:movie_recommendation_app/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app/features/movie_flow/genre/list_card.dart';
import 'package:movie_recommendation_app/features/movie_flow/movie_flow_controller.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(movieFlowControllerProvider.notifier).previousPage();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed:
                ref.read(movieFlowControllerProvider.notifier).previousPage,
          ),
        ),
        body: Center(
            child: Column(
          children: [
            Text(
              'Let\'s start with a genre',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: ref.watch(movieFlowControllerProvider).genres.when(
                    data: (genres) {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            final genre = genres[index];
                            return ListCard(
                                genre: genre,
                                onTap: () => ref
                                    .read(movieFlowControllerProvider.notifier)
                                    .toggleSelected(genre));
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: kListItemSpacing);
                          },
                          padding: const EdgeInsets.symmetric(
                              vertical: kListItemSpacing),
                          itemCount: genres.length);
                    },
                    error: (error, s) {
                      if (error is Failure) {
                        return FailureBody(message: error.message);
                      }
                      return const FailureBody(message: "Something went wrong");
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()))),
            PrimaryButton(
                onPressed:
                    ref.read(movieFlowControllerProvider.notifier).nextPage,
                text: 'Continue'),
            const SizedBox(height: kMediumSpacing),
          ],
        )),
      ),
    );
  }
}
