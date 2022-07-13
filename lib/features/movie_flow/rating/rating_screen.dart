import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app_course/core/constants.dart';
import 'package:movie_recommendation_app_course/core/widgets/primary_button.dart';
import 'package:movie_recommendation_app_course/features/movie_flow/movie_flow_controller.dart';

class RatingScreen extends ConsumerWidget {
  const RatingScreen({
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
                'Select a minimum rating\nranging from 1 to 10',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${ref.watch(movieFlowControllerProvider).rating}',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 62,
                  ),
                ],
              ),
              const Spacer(),
              Slider(
                value: ref.watch(movieFlowControllerProvider).rating.toDouble(),
                onChanged: (value) {
                  ref
                      .read(movieFlowControllerProvider.notifier)
                      .updateRating(value.toInt());
                },
                min: 1,
                max: 10,
                divisions: 9,
                label: '${ref.watch(movieFlowControllerProvider).rating}',
              ),
              const Spacer(),
              PrimaryButton(
                  onPressed:
                      ref.read(movieFlowControllerProvider.notifier).nextPage,
                  text: 'Yes please'),
              const SizedBox(height: kMediumSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
