import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HistoryDrawer extends StatelessWidget {
  final Map<String, dynamic> history;
  final Function(File, Map<String, dynamic>) onHistoryItemTap;

  const HistoryDrawer({
    Key? key,
    required this.history,
    required this.onHistoryItemTap,
  }) : super(key: key);

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
  Future<File> downloadWebpAsFile(String imageUrl) async {
    try {
      // Create HTTP request to get the image
      final http.Client client = http.Client();
      final http.Response response = await client.get(Uri.parse(imageUrl));
      client.close();

      // Check if the request was successful
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to download image: HTTP ${response.statusCode}',
        );
      }

      // Get temporary directory for storing the file
      final tempDir = await getTemporaryDirectory();

      // Determine the filename
      final String finalFilename =
          'webp_image_${DateTime.now().millisecondsSinceEpoch}.webp';

      // Ensure webp extension
      final String fullFilename =
          finalFilename.toLowerCase().endsWith('.webp')
              ? finalFilename
              : '$finalFilename.webp';

      // Create the file path
      final filePath = path.join(tempDir.path, fullFilename);

      // Write the image data to the file
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(response.bodyBytes);

      return imageFile;
    } catch (e) {
      throw Exception('Error downloading WebP image: $e');
    }
  }
}
