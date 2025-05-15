import 'dart:io';

import 'package:agriwise/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:agriwise/screens/disease_detection/result_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class AnalyzingScreen extends StatefulWidget {
  final XFile imageFile;

  const AnalyzingScreen({super.key, required this.imageFile});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  final int _selectedIndex = 0; // 0 for Home since this is not Profile

  int _dotCount = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start the animated dots
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotCount = (_dotCount % 3) + 1;
      });
    });

    // Simulate analysis delay

    // In a real app, you would poll the API for analysis results
    HttpService()
        .predictDisease(widget.imageFile)
        .then((results) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ResultScreen(
                    imageFile: File(widget.imageFile.path),
                    results: results,
                  ),
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $error')));
          Navigator.pop(context);
        });
    // For now, just navigate to result screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ResultScreen(imageFile: widget.imageFile),
    //   ),
    // );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Disease Detection',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/camera.svg',
              width: 120,
              height: 120,
              placeholderBuilder: (BuildContext context) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.search,
                    size: 60,
                    color: const Color(0xFF3C8D40),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Analyzing Image${'.' * _dotCount}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Please wait while we scan your plant\nfor potential diseases using AI.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
