import 'dart:io';

import 'package:agriwise/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:agriwise/screens/seeding_quality/result_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:agriwise/screens/home_screen.dart';
import 'package:agriwise/screens/profile_screen.dart';

class SeedingQualityAnalyzingScreen extends StatefulWidget {
  final File imageFile;

  const SeedingQualityAnalyzingScreen({required this.imageFile}) : super();

  @override
  State<SeedingQualityAnalyzingScreen> createState() =>
      _SeedingQualityAnalyzingScreenState();
}

class _SeedingQualityAnalyzingScreenState
    extends State<SeedingQualityAnalyzingScreen> {
  int _selectedIndex = 0; // 0 for Home since this is not Profile
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

    HttpService()
        .predictSeedQuality(widget.imageFile)
        .then((result) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SeedingQualityResultScreen(
                    imageFile: widget.imageFile,
                    result: result,
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
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Seeding Quality',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
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
            Image.asset(
              'assets/icons/ai_analyzing.png', // Replace with your actual asset
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
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
                'Please wait while we scan your seed for quality assessment using AI.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3C8D40)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Bottom navigation bar
  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.person, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    final color = isSelected ? const Color(0xFF3C8D40) : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (label == 'Home') {
          if (_selectedIndex != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else if (label == 'Profile') {
          if (_selectedIndex != 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
