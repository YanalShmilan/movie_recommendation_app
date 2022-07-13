import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendation_app/core/constants.dart';
import 'package:movie_recommendation_app/core/failure.dart';
import 'package:movie_recommendation_app/core/widgets/failure_screen.dart';
import 'package:movie_recommendation_app/core/widgets/primary_button.dart';

import 'package:movie_recommendation_app/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendation_app/features/movie_flow/result/movie.dart';

class ResultScreen extends ConsumerWidget {
  static route({bool fullscreenDialog = true}) {
    return MaterialPageRoute(
      builder: (context) => const ResultScreen(),
      fullscreenDialog: fullscreenDialog,
    );
  }

  const ResultScreen({Key? key}) : super(key: key);

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(movieFlowControllerProvider).movie.when(
        data: (movie) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CoverImage(
                            image: movie.posterPath!,
                            height: movieHeight,
                          ),
                          Positioned(
                            width: MediaQuery.of(context).size.width,
                            bottom: -(movieHeight / 2),
                            child: MovieImageDetails(
                              movie: movie,
                              movieHeight: movieHeight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: movieHeight / 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          movie.overview,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
                PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Find another movie'),
                const SizedBox(height: kMediumSpacing),
              ],
            ),
          );
        },
        error: (error, s) {
          if (error is Failure) {
            return FailureScreen(message: error.message);
          }
          return const FailureScreen(
            message: "Something went Wrong!",
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

class MovieImageDetails extends StatelessWidget {
  @override
  final Movie movie;
  final double movieHeight;

  const MovieImageDetails(
      {Key? key, required this.movie, required this.movieHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: movieHeight,
            child: Image.network(
              movie.posterPath!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      movie.voteAverage,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.color
                                ?.withOpacity(0.62),
                          ),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CoverImage extends StatelessWidget {
  const CoverImage({
    Key? key,
    required this.height,
    required this.image,
  }) : super(key: key);
  final double height;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      constraints: const BoxConstraints(minHeight: 298),
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: Image.network(
          image,
          width: double.infinity,
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
