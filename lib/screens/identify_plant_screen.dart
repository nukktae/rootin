import 'dart:developer' as dev;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'name_input_screen.dart';

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
        setState(() {
          _error = 'Authorization token is missing';
          _isLoading = false;
        });
        return;
      }

      // Verify file exists and size
      dev.log('Image path: ${widget.imageFile.path}');
      dev.log('Image exists: ${widget.imageFile.existsSync()}');
      dev.log('Image size: ${widget.imageFile.lengthSync()} bytes');

      final url = Uri.parse('https://api.rootin.me/v1/plant-types/images');
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add file to request
      var multipartFile = await http.MultipartFile.fromPath(
        'file',
        widget.imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      dev.log('Sending request to API...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      dev.log('Response status: ${response.statusCode}');
      dev.log('Response body: ${response.body}');

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
            // Main content - moved lower
            Padding(
              padding: const EdgeInsets.only(top: 120), // Added top padding to move content down
              child: _isLoading
                  ? _buildLoadingState()
                  : _error != null
                      ? _buildErrorState()
                      : _buildIdentifiedPlantContent(),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // User's uploaded/captured image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: FileImage(widget.imageFile),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Plant name and scientific name
          Text(
            _identifiedPlant?['name'] ?? 'Identified Plant',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _identifiedPlant?['subname'] ?? 'Scientific Name',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6F6F6F),
            ),
          ),
          const SizedBox(height: 48),
          
          // API reference image
          Container(
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
              child: const Text(
                'Add Plant',
                style: TextStyle(
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
            child: const Text(
              'Retake Photo',
              style: TextStyle(
                color: Color(0xFF6F6F6F),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Failed to identify plant',
            style: TextStyle(
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
