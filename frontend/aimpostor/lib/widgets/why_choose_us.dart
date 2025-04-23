// lib/widgets/why_choose_us.dart
import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Choose Us',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 150,
                height: 150,
                color: Colors.grey.shade400,
              ),

              const SizedBox(width: 10),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 8; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        height: 10,
                        width: double.infinity,
                        color: Colors.grey.shade400,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}