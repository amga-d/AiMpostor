// lib/widgets/features_section.dart
import 'package:flutter/material.dart';
import 'feature_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of feature titles for demonstration
    final List<String> features = [
      'Plant Disease Detection',
      'Seed Quality Analysis',
      'Pest Growth Prediction',
      'Crop Yield Forecasting',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          for (int i = 0; i < features.length; i++)
            FeatureCard(
              title: features[i],
              index: i,
            ),
        ],
      ),
    );
  }
}