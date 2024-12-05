import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'dart:io';

class PlantDetectorService {
  static ObjectDetector? _objectDetector;
  static const String _modelPath = 'assets/ml/efficientdet_lite0.tflite';
  static const String _labelsPath = 'assets/ml/labels.txt';

  static Future<void> initialize() async {
    try {
      // Copy model from assets if it doesn't exist
      final modelFile = File(_modelPath);
      if (!modelFile.existsSync()) {
        final modelBytes = await rootBundle.load(_modelPath);
        await modelFile.writeAsBytes(modelBytes.buffer.asUint8List());
      }

      final options = LocalObjectDetectorOptions(
        mode: DetectionMode.single,
        modelPath: _modelPath,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    } catch (e) {
      print('Error initializing plant detector: $e');
    }
  }

  static Future<bool> detectPlant(img.Image image) async {
    try {
      final inputImage = InputImage.fromBytes(
        bytes: image.getBytes(),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.bgra8888,
          bytesPerRow: image.width * 4,
        ),
      );

      final objects = await _objectDetector?.processImage(inputImage);
      return objects?.any((element) => 
        element.labels.any((label) => 
          label.text.toLowerCase().contains('plant') ||
          label.text.toLowerCase().contains('flower') ||
          label.text.toLowerCase().contains('tree'))) ?? false;
    } catch (e) {
      print('Error detecting plant: $e');
      return false;
    }
  }

  static void dispose() {
    _objectDetector?.close();
  }
} 