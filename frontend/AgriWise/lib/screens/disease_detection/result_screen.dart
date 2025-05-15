import 'package:flutter/material.dart';
import 'package:agriwise/screens/disease_detection/chatbot_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:agriwise/screens/home_screen.dart';
import 'package:agriwise/screens/profile_screen.dart';

class ResultScreen extends StatefulWidget {
  final XFile imageFile;
  final Map<String, dynamic> results;

  const ResultScreen({required this.imageFile, required this.results})
    : super();

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _selectedIndex = 0; // 0 for Home since this is not Profile

  @override
  Widget build(BuildContext context) {
    final response = widget.results['response'] ?? {};
    final crop = response['crop'] ?? 'Unknown';
    final detectedDisease = response['detectedDisease'] ?? 'Unknown';
    final riskLevel = response['riskLevel'] ?? 'Unknown';
    final aboutDisease =
        response['aboutDisease'] ?? 'No information available.';
    final recommendedActions = response['recommendedAction'] ?? [];
    final chatId = widget.results['chatId'] ?? 'Unknown';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Disease Detection',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 361,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xffA8A8A8), width: 1),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Plant Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(widget.imageFile.path),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Results Container with floating label
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main container with green border
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3C8D40),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top section with light green background
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECF8ED),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(11),
                                topRight: Radius.circular(11),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildResultRow('Crop', crop),
                                const SizedBox(height: 6),
                                _buildResultRow(
                                  'Detected Disease',
                                  detectedDisease,
                                ),
                                const SizedBox(height: 6),
                                _buildResultRow(
                                  'Risk Level',
                                  riskLevel,
                                  valueColor:
                                      riskLevel == 'High'
                                          ? Colors.red.shade700
                                          : Colors.black,
                                ),
                              ],
                            ),
                          ),

                          // Bottom section with white background
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(11),
                                bottomRight: Radius.circular(11),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'About This Disease',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  aboutDisease,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Recommended Action',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...recommendedActions.map<Widget>(
                                  (action) => _buildBulletPoint(action),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Floating "Analysis Complete" label
                    Positioned(
                      top: -15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffA8A8A8),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xffA8A8A8),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Analysis Complete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // Expert guidance section
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Need expert guidance?',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatbotScreen(chatId: chatId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF307C42),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Ask AI Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          ':',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

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
