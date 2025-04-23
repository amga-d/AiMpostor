// lib/widgets/feature_card.dart
import 'package:flutter/material.dart';
import '../screens/disease_detection.dart'; // Import disease detection page

class FeatureCard extends StatelessWidget {
  final String title;
  final int index;

  const FeatureCard({
    super.key,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate only for Plant Disease Detection (index 0)
        if (index == 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const DiseaseDetectionPage()),
          );
        } else {
          // For other cards, show a message that the feature is coming soon
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This feature is coming soon!')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature image placeholder
            Container(
              width: 100,
              height: 100,
              color: Colors.grey.shade400,
            ),

            const SizedBox(width: 10),

            // Feature text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Feature title
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Lines of text
                  for (int i = 0; i < 3; i++)
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      height: 10,
                      width: double.infinity,
                      color: Colors.grey.shade400,
                    ),

                  const SizedBox(height: 10),

                  // Action button
                  GestureDetector(
                    onTap: () {
                      // Navigate only for Plant Disease Detection (index 0)
                      if (index == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const DiseaseDetectionPage()),
                        );
                      } else {
                        // For other cards, show a message that the feature is coming soon
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('This feature is coming soon!')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      color: Colors.red.shade400,
                      child: const Text(
                        'Learn More',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}