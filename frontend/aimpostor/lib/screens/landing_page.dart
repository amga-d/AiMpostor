// lib/screens/landing_page.dart
import 'package:flutter/material.dart';
import '../widgets/header_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_title.dart';
import '../widgets/features_section.dart';
import '../widgets/why_choose_us.dart';
import '../widgets/footer_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // Header section with logo and buttons
            HeaderSection(),
            // Hero section with text and button
            HeroSection(),
            // Features section title
            FeaturesTitle(),
            // Features list section
            FeaturesSection(),
            // Why Choose Us section
            WhyChooseUsSection(),
            // Footer section
            FooterSection(),
          ],
        ),
      ),
    );
  }
}