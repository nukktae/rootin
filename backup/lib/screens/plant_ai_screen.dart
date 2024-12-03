import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../widgets/input_bar.dart';
import '../widgets/suggestion_bar.dart';

class PlantAIScreen extends StatefulWidget {
  const PlantAIScreen({super.key});

  @override
  PlantAIScreenState createState() => PlantAIScreenState();
}

class PlantAIScreenState extends State<PlantAIScreen> {
  String sessionId = "";
  final List<Map<String, dynamic>> chatMessages = [];
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeSession();
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
        selectedImage = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Plant AI',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: chatMessages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/loading_logo.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      final isUser = message['sender'] == 'user';
                      final isAI = message['sender'] == 'ai';

                      return Container(
                        margin: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment:
                              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            if (message['image'] != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Image.file(
                                  message['image'],
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: isAI
                                  ? MarkdownBody(
                                      data: message['message'] ?? '',
                                      styleSheet: MarkdownStyleSheet(
                                        p: TextStyle(
                                          color: isUser ? Colors.white : Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    )
                                  : Text(
                                      message['message'] ?? '',
                                      style: TextStyle(
                                        color: isUser ? Colors.white : Colors.black,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (chatMessages.isEmpty)
            SuggestionBar(
              suggestions: const [
                "How to solve water-logged problems",
                "Proper watering techniques",
                "Frequency of watering",
              ],
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