import 'package:flutter/material.dart';
import 'dart:io';

class PlantIdentificationScreen extends StatelessWidget {
  final Map<String, dynamic> plantDetails;
  final VoidCallback onRetakePhoto;

  const PlantIdentificationScreen({
    super.key,
    required this.plantDetails,
    required this.onRetakePhoto,
  });

  @override
  Widget build(BuildContext context) {
    // Add null safety checks for the required fields
    final name = plantDetails['name'] as String? ?? 'Unknown Plant';
    final subname = plantDetails['subname'] as String? ?? 'Scientific name unavailable';
    final imagePath = plantDetails['imagePath'] as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Close Button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 30),

            // Plant Details
            if (imagePath.isNotEmpty) 
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(imagePath)),
              ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subname,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Add Plant Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen (e.g., nickname input screen)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Plant',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            // Retake Photo Button
            TextButton(
              onPressed: onRetakePhoto,
              child: const Text(
                'Retake Photo',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
