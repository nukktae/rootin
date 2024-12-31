import 'dart:developer' as dev;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'name_input_screen.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../l10n/app_localizations.dart';
class IdentifyPlantScreen extends StatefulWidget {
  final File imageFile;

  const IdentifyPlantScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<IdentifyPlantScreen> createState() => _IdentifyPlantScreenState();
}

class _IdentifyPlantScreenState extends State<IdentifyPlantScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic>? _identifiedPlant;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _identifyPlant();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _identifyPlant() async {
    try {
      if (!mounted) return;
      dev.log('Starting plant identification...');
      final token = dotenv.get('FCM_TOKEN');
      
      if (token.isEmpty) {
        dev.log('Token is empty');
        if (!mounted) return;
        setState(() {
          _error = 'Authorization token is missing';
          _isLoading = false;
        });
        return;
      }

      // Check if image exists and is valid
      if (!widget.imageFile.existsSync()) {
        if (!mounted) return;
        setState(() {
          _error = 'Image file not found';
          _isLoading = false;
        });
        return;
      }

      // Convert HEIC to JPEG if necessary
      File imageToUpload = widget.imageFile;
      if (widget.imageFile.path.toLowerCase().endsWith('.heic')) {
        final tempDir = await Directory.systemTemp.create();
        final targetPath = '${tempDir.path}/converted_image.jpg';
        
        final result = await FlutterImageCompress.compressAndGetFile(
          widget.imageFile.path,
          targetPath,
          format: CompressFormat.jpeg,
          quality: 90,
        );
        
        if (result != null) {
          imageToUpload = File(result.path);
        } else {
          throw Exception('Failed to convert HEIC image');
        }
      }

      final url = Uri.parse('https://api.rootin.me/v1/plant-types/images');
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Use the converted image
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        imageToUpload.path,
      );
      request.files.add(multipartFile);

      dev.log('Sending request to API...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      dev.log('Response status: ${response.statusCode}');
      dev.log('Response body: ${response.body}');

      if (!mounted) return;
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null) {
          setState(() {
            _identifiedPlant = responseData['data'];
            _isLoading = false;
          });
          dev.log('Plant identified successfully: $_identifiedPlant');
        } else {
          throw Exception('No plant data in response');
        }
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Error during identification: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content - wrapped in SingleChildScrollView
            Padding(
              padding: const EdgeInsets.only(top: 80), // Reduced from 120 to 80
              child: SingleChildScrollView(
                child: _isLoading
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: _buildLoadingState(),
                      )
                    : _error != null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            child: _buildErrorState(),
                          )
                        : _buildIdentifiedPlantContent(),
              ),
            ),
            
            // Close button - stays at top
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Image.asset(
                  'assets/icons/loading_logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdentifiedPlantContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User's uploaded image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              widget.imageFile,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          
          // Plant name and scientific name
          Text(
            _identifiedPlant?['name'] ?? AppLocalizations.of(context).identifiedPlant,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _identifiedPlant?['subname'] ?? AppLocalizations.of(context).scientificName,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6F6F6F),
            ),
          ),
          const SizedBox(height: 48),
          
          // API reference image
          Hero(
            tag: 'plant_image_${_identifiedPlant?['id']}',
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(_identifiedPlant?['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 64),
          
          // Add Plant button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NameInputScreen(
                      plantId: _identifiedPlant?['id'] ?? '',
                      plantName: _identifiedPlant?['name'] ?? '',
                      scientificName: _identifiedPlant?['subname'] ?? '',
                      imageUrl: _identifiedPlant?['imageUrl'] ?? '',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context).addPlant,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Retake Photo button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).retakePhoto,
              style: const TextStyle(
                color: Color(0xFF6F6F6F),
                fontSize: 16,
              ),
            ),
          ),
          
          // Add extra bottom padding for better scrolling
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).failedToIdentify,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _identifyPlant,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}