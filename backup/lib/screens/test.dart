import '../services/api_client.dart';
import 'dart:developer' as developer;
import 'dart:io';

void main() async {
  final ApiClient apiClient = ApiClient();
  const String testImagePath = 'assets/test_image/Sunflower.jpg'; // Ensure the file exists

  try {
    // Verify the image file exists
    final file = File(testImagePath);
    if (!file.existsSync()) {
      throw Exception("File not found at path: $testImagePath");
    }

    developer.log("Testing the identifyPlant function with image: $testImagePath");

    final result = await apiClient.identifyPlant(testImagePath);
    developer.log("Plant Identification Result: $result");
  } catch (e) {
    developer.log("Error occurred during plant identification: $e");
  }
}
