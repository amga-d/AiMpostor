import 'package:agriwise/services/http_service.dart';
import 'package:flutter/material.dart';

import 'package:agriwise/screens/home_screen.dart';
import 'package:agriwise/screens/profile_screen.dart';

class FertilizerRecipeScreen extends StatefulWidget {
  const FertilizerRecipeScreen({Key? key}) : super(key: key);

  @override
  State<FertilizerRecipeScreen> createState() => _FertilizerRecipeScreenState();
}

class _FertilizerRecipeScreenState extends State<FertilizerRecipeScreen> {
  int _selectedIndex = 0; // 0 for Home since this is not Profile
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _plantsController = TextEditingController();
  bool _showRecipe = false;
  String _plantType = '';
  Map<String, dynamic>? _recipeData;
  bool _isLoading = false;

  @override
  void dispose() {
    _materialsController.dispose();
    _plantsController.dispose();
    super.dispose();
  }

  Future<void> _getRecipe() async {
    final plantInput = _plantsController.text.trim();
    final materialsInput = _materialsController.text.trim();

    if (plantInput.isEmpty || materialsInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _showRecipe = false;
    });

    try {
      final response = await HttpService().getFertilizerRecipe(
        plantInput,
        materialsInput,
      );

      if (response != null) {
        setState(() {
          _plantType = response['plant'] ?? plantInput;
          _recipeData = response;
          _showRecipe = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get recipe. Please try again.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Fertilizer Recipe',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xffA8A8A8), width: 1),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tell us what materials you have, and we\'ll help you create a fertilizer mix for your plants.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'What materials do you have?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: _materialsController,
                        decoration: InputDecoration(
                          hintText: 'manure, banana peel, ashes...',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                        ),
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'What plant are you growing?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: TextField(
                        controller: _plantsController,
                        decoration: InputDecoration(
                          hintText: 'tomatoes, rice, chili..',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffC9C9C9),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _getRecipe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF307C42),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Get Recipe',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_showRecipe && _recipeData != null) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFECF8ED),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF3C8D40),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggested Fertilizer Recipe for Your $_plantType Plant: ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Mix the following ingredients:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_recipeData!['recipe'] != null &&
                          _recipeData!['recipe']['ingredients'] != null)
                        ..._buildIngredientsList(
                          _recipeData!['recipe']['ingredients'],
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_recipeData!['recipe'] != null &&
                          _recipeData!['recipe']['instructions'] != null)
                        ..._buildInstructionsList(
                          _recipeData!['recipe']['instructions'],
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  List<Widget> _buildIngredientsList(List<dynamic> ingredients) {
    return ingredients.map<Widget>((ingredient) {
      if (ingredient is Map<String, dynamic>) {
        return _buildBulletPoint(
          '${ingredient['quantity'] ?? ''} ${ingredient['material'] ?? ''}',
        );
      } else if (ingredient is String) {
        return _buildBulletPoint(ingredient);
      }
      return Container();
    }).toList();
  }

  List<Widget> _buildInstructionsList(List<dynamic> instructions) {
    return instructions.map<Widget>((instruction) {
      if (instruction is String) {
        return _buildBulletPoint(instruction);
      }
      return Container();
    }).toList();
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
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
