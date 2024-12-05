import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../widgets/plant_ai_title_bar.dart';
import '../widgets/input_bar.dart';
import '../widgets/suggestion_bar.dart'; // Import the SuggestionBar widget.
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class AIChatbotScreen extends StatefulWidget {
  final Plant? plant;

  const AIChatbotScreen({
    super.key,
    this.plant,
  });

  @override
  State<AIChatbotScreen> createState() => AIChatbotScreenState();
}

class AIChatbotScreenState extends State<AIChatbotScreen> with SingleTickerProviderStateMixin {
  String sessionId = "";
  final List<Map<String, dynamic>> chatMessages = [];
  final TextEditingController _questionController = TextEditingController();
  bool isLoading = false;
  File? selectedImage;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initializeSession();
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

  Future<void> _initializeSession() async {
    final String? fcmToken = dotenv.env['FCM_TOKEN'];
    if (fcmToken == null || fcmToken.isEmpty) {
      setState(() {
        chatMessages.add({"sender": "system", "message": "Error: Missing FCM Token."});
      });
      return;
    }

    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $fcmToken',
    };

    final url = Uri.parse('https://api.rootin.me/v1/chat/prompt/new-session');

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sessionId = data['sessionId'];
        });
      } else {
        setState(() {
          chatMessages.add({
            "sender": "system",
            "message": "Failed to initialize session. Status code: ${response.statusCode}"
          });
        });
      }
    } catch (e) {
      setState(() {
        chatMessages.add({"sender": "system", "message": "Error initializing session: $e"});
      });
    }
  }

  Future<void> _sendMessage(String question) async {
    if (sessionId.isEmpty) {
      setState(() {
        chatMessages.add({"sender": "system", "message": "Error: Session ID is not initialized."});
      });
      return;
    }

    final String? fcmToken = dotenv.env['FCM_TOKEN'];
    if (fcmToken == null || fcmToken.isEmpty) {
      setState(() {
        chatMessages.add({"sender": "system", "message": "Error: Missing FCM Token."});
      });
      return;
    }

    final url = Uri.parse('https://api.rootin.me/v1/chat/prompt/$sessionId');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $fcmToken',
    });

    request.fields['query'] = question;

    if (selectedImage != null) {
      final file = await http.MultipartFile.fromPath('image', selectedImage!.path);
      request.files.add(file);
    }

    setState(() {
      isLoading = true;
      chatMessages.add({
        "sender": "user",
        "message": question,
        "image": selectedImage,
      });
      selectedImage = null;
    });

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody);

      setState(() {
        if (response.statusCode == 200) {
          chatMessages.add({
            "sender": "ai",
            "message": data['result'] ?? "No response received.",
          });
        } else {
          chatMessages.add({
            "sender": "system",
            "message": "Failed to get response. Status code: ${response.statusCode}"
          });
        }
      });
    } catch (e) {
      setState(() {
        chatMessages.add({"sender": "system", "message": "Error sending message: $e"});
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Widget _buildLoadingIndicator() {
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
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _getSuggestions() {
    final localizations = AppLocalizations.of(context);
    
    if (widget.plant != null) {
      return [
        "${localizations.careInstructions} ${widget.plant!.plantTypeName}?",
        "${localizations.wateringSchedule} ${widget.plant!.plantTypeName}?",
        "${localizations.commonProblems} ${widget.plant!.plantTypeName}",
      ];
    }
    return [
      localizations.askAboutWatering,
      localizations.properWatering,
      localizations.wateringFrequency,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffE7E7E7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ),
        toolbarHeight: 72,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 0, left: 16),
          child: PlantAITitleBar(plant: widget.plant),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Chat messages
                chatMessages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: _buildLoadingIndicator(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          final message = chatMessages[index];
                          final isUser = message['sender'] == 'user';
                          final isAI = message['sender'] == 'ai';

                          return Container(
                            margin: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            color: const Color(0xFFF6F6F6),
                            child: Column(
                              crossAxisAlignment:
                                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                if (message['image'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        message['image'],
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                Row(
                                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUser && isAI)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: Image.asset(
                                            'assets/images/rootinnotif.png',
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isUser ? Colors.blue : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: isAI
                                          ? MarkdownBody(data: message['message'] ?? '')
                                          : Text(
                                              message['message'] ?? '',
                                              style: TextStyle(
                                                color: isUser ? Colors.white : Colors.black,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                
                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: _buildLoadingIndicator(),
                  ),
              ],
            ),
          ),
          if (selectedImage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey[200],
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedImage!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        selectedImage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          if (chatMessages.isEmpty && selectedImage == null)
            SuggestionBar(
              suggestions: _getSuggestions(),
              onSuggestionTap: (suggestion) => _sendMessage(suggestion),
            ),
          InputBar(
            questionController: _questionController,
            onSendMessage: (question) => _sendMessage(question),
            onPickImageFromGallery: _pickImageFromGallery,
            onPickImageFromCamera: _pickImageFromCamera,
          ),
        ],
      ),
    );
  }
}
