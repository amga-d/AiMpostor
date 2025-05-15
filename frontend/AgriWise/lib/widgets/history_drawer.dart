import 'package:agriwise/helpers/download_webp_as_file.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class HistoryDrawer extends StatelessWidget {
  final Map<String, dynamic> history;
  final Function(File, Map<String, dynamic>) onHistoryItemTap;

  const HistoryDrawer({
    super.key,
    required this.history,
    required this.onHistoryItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: const Row(
              children: [
                Icon(Icons.history, size: 24),
                SizedBox(width: 10),
                Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: history['assessments']?.length ?? 0,
              itemBuilder: (context, index) {
                if (history['assessments'] == null ||
                    history['assessments'].isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'No history available',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  );
                }
                final reversedIndex =
                    (history['assessments'].length - 1) - index;
                final assessment = history['assessments'][reversedIndex];
                final title =
                    assessment['formattedDate'] != null
                        ? 'Seed Quality check - ${assessment['formattedDate']}'
                        : 'Seed Quality check';
                return ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onTap: () {
                    downloadWebpAsFile(assessment['seedImageUrl']).then((file) {
                      onHistoryItemTap(file, assessment);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to download image
}
