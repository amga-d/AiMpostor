// lib/screens/disease_detection.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import 'chatbot.dart';

class DiseaseDetectionPage extends StatefulWidget {
  const DiseaseDetectionPage({super.key});

  @override
  State<DiseaseDetectionPage> createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File? _imageFile;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;
  PageState _currentState = PageState.initial;
  final AIService _aiService = AIService();

  // Take a photo using the camera
  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
        _currentState = PageState.reviewPhoto;
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
        _currentState = PageState.reviewPhoto;
      });
    }
  }

  // Analyze the selected image
  Future<void> _analyzeImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isAnalyzing = true;
      _currentState = PageState.analyzing;
    });

    try {
      // Call AI service to analyze the image
      final results = await _aiService.analyzePlantDisease(_imageFile!);

      setState(() {
        _analysisResults = results;
        _isAnalyzing = false;
        _currentState = PageState.results;
      });
    } catch (e) {
      print('Error analyzing image: $e');
      setState(() {
        _isAnalyzing = false;
        _currentState = PageState.reviewPhoto;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to analyze image. Please try again.')),
      );
    }
  }

  // Restart the process
  void _retakePhoto() {
    setState(() {
      _imageFile = null;
      _currentState = PageState.initial;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentState) {
      case PageState.initial:
        return _buildInitialPage();
      case PageState.reviewPhoto:
        return _buildReviewPage();
      case PageState.analyzing:
        return _buildAnalyzingPage();
      case PageState.results:
        return _buildResultsPage();
      default:
        return _buildInitialPage();
    }
  }

  // Initial page with options to take photo or choose from album
  Widget _buildInitialPage() {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Plant Disease Detection'),
      backgroundColor: Colors.green,
      actions: [
        // Add action button to access chat directly
        IconButton(
          icon: const Icon(Icons.chat),
          onPressed: () {
            // Navigate to chatbot page without any analysis results
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChatbotPage(
                  analysisResults: null,
                ),
              ),
            );
          },
          tooltip: 'Chat with AI',
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        children: [
          // Main content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Grey lines (title placeholders)
                  Container(
                    height: 12,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    height: 12,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.only(bottom: 24),
                  ),

                  // Image placeholder with icon
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate,
                            size: 48,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'or',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade500,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Choose from album',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Add direct chat button
                          TextButton(
                            onPressed: () {
                              // Navigate to chatbot page without any analysis results
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ChatbotPage(
                                    analysisResults: null,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Or chat directly with our AI assistant',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Take photo button
                  ElevatedButton(
                    onPressed: _takePhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'take photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // Page to review the captured photo
  Widget _buildReviewPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Photo'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grey lines (title placeholders)
              Container(
                height: 12,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.only(bottom: 8),
              ),
              Container(
                height: 12,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.only(bottom: 24),
              ),

              // Image preview
              Expanded(
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        color: Colors.grey.shade400,
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.black45,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Retake button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _retakePhoto,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'retake',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Analyze button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _analyzeImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Analyze Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Page showing analyzing state
  Widget _buildAnalyzingPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyzing...'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grey lines (title placeholders)
              Container(
                height: 12,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.only(bottom: 8),
              ),
              Container(
                height: 12,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.only(bottom: 8),
              ),
              Container(
                height: 12,
                color: Colors.grey.shade400,
                margin: const EdgeInsets.only(bottom: 24),
              ),

              // Loading indicator
              Expanded(
                child: Container(
                  color: Colors.grey.shade400,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.black54,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'loading',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Page showing analysis results
  Widget _buildResultsPage() {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Analysis Results'),
      backgroundColor: Colors.green,
    ),
    body: SafeArea(
      child: Column(
        children: [
          // Main content
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Result title
                  Container(
                    height: 12,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),

                  // Result content area
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade400,
                      padding: const EdgeInsets.all(16),
                      child: _analysisResults != null
                        ? _analysisResults!.containsKey('error')
                          // Error case - not a plant or no disease detected
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _analysisResults!['error'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Please try again with a clear image of a plant showing disease symptoms.',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          // Success case - plant disease detected
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Results',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      'Disease: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(_analysisResults!['disease_name']),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Severity: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(_analysisResults!['severity']),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Confidence: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('${_analysisResults!['confidence_percentage']}%'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Symptoms:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(_analysisResults!['symptoms']),
                              ],
                            )
                        // Loading case
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Additional result lines
                  Container(
                    height: 12,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                  Container(
                    height: 12,
                    color: Colors.grey.shade400,
                    margin: const EdgeInsets.only(bottom: 24),
                  ),
                ],
              ),
            ),
          ),

          // Ask AI button - only show for valid plant disease detections
          if (_analysisResults != null && !_analysisResults!.containsKey('error'))
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to chatbot page with analysis results
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatbotPage(
                        analysisResults: _analysisResults,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'ask our ai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

          // Retry button - show for errors
          if (_analysisResults != null && _analysisResults!.containsKey('error'))
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _retakePhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}

// Enum to track the current page state
enum PageState {
  initial,
  reviewPhoto,
  analyzing,
  results,
}