import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopSensorScreen extends StatelessWidget {
  const ShopSensorScreen({super.key});

  Future<void> _launchWaitlist() async {
    final Uri url = Uri.parse('https://www.rootin.me');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Text('Intro', style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Text('Help', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, color: Colors.white),
            Text(' Plant Shop', style: TextStyle(color: Colors.white)),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF00D37F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "You're on the waitlist!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Current Position',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.3, // Adjust based on position
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D37F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'EARLY ACCESS',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  'GENERAL ADMISSION',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "You'll get early access. We'll send you a\nnotification once the shop is ready for you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 