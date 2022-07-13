import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/core/constants.dart';
import 'package:movie_recommendation_app_course/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({
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
            children: <Widget>[
              Text(
                'How many years back should we check for?',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${ref.watch(movieFlowControllerProvider).yearsBack}',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    'Years back',
                    style: Theme.of(context).textTheme.headline4?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.color
                            ?.withOpacity(0.67)),
                  ),
                ],
              ),
              const Spacer(),
              Slider(
                value:
                    ref.watch(movieFlowControllerProvider).yearsBack.toDouble(),
                onChanged: (value) {
                  ref
                      .read(movieFlowControllerProvider.notifier)
                      .updateYearsBack(value.toInt());
                },
                min: 0,
                max: 70,
                divisions: 70,
                label: '${ref.watch(movieFlowControllerProvider).yearsBack}',
              ),
              const Spacer(),
              PrimaryButton(
                  onPressed: () async {
                    ref
                        .read(movieFlowControllerProvider.notifier)
                        .getRecommendedMovie();
                    Navigator.of(context).push(ResultScreen.route());
                  },
                  isLoading: ref.read(movieFlowControllerProvider).movie
                      is AsyncLoading,
                  text: 'Amazing'),
              const SizedBox(height: kMediumSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
