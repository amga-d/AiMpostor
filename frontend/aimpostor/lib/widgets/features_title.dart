// lib/widgets/features_title.dart
import 'package:flutter/material.dart';

class FeaturesTitle extends StatelessWidget {
  const FeaturesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: const Text(
        'Our Features',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}