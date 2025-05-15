import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Helper method to download image
Future<File> downloadWebpAsFile(String imageUrl) async {
  try {
    // Create HTTP request to get the image
    final http.Client client = http.Client();
    final http.Response response = await client.get(Uri.parse(imageUrl));
    client.close();

    // Check if the request was successful
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: HTTP ${response.statusCode}');
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
