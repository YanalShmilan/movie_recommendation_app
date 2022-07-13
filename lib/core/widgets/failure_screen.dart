import 'package:flutter/material.dart';
import 'package:movie_recommendation_app_course/core/widgets/failure_body.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FailureBody(message: message),
    );
  }
}
