import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class InputBar extends StatefulWidget {
  final TextEditingController questionController;
  final Function(String) onSendMessage;
  final VoidCallback onPickImageFromGallery;
  final VoidCallback onPickImageFromCamera;

  const InputBar({
    super.key,
    required this.questionController,
    required this.onSendMessage,
    required this.onPickImageFromGallery,
    required this.onPickImageFromCamera,
  });

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  bool isDialOpen = false;
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      var hasSpeech = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );
      
      if (hasSpeech) {
        print('Speech recognition initialized successfully');
      } else {
        print('Speech recognition failed to initialize');
      }
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Speech recognition initialization error: $e');
    }
  }

  String _getLocaleId(BuildContext context) {
    final locale = Provider.of<LanguageProvider>(context, listen: false).currentLocale;
    // Map language codes to speech recognition locale IDs
    switch (locale.languageCode) {
      case 'ko':
        return 'ko-KR';
      case 'en':
      default:
        return 'en-US';
    }
  }

  void _startListening() async {
    try {
      if (!_speechToText.isAvailable) {
        print('Speech recognition is not available');
        return;
      }

      final localeId = _getLocaleId(context);
      
      await _speechToText.listen(
        onResult: (result) {
          if (mounted) {
            setState(() {
              widget.questionController.text = result.recognizedWords;
            });
          }
        },
        localeId: localeId, // Use the appropriate locale based on app language
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );
      
      if (mounted) {
        setState(() {
          _isListening = true;
        });
      }
    } catch (e) {
      print('Error starting speech recognition: $e');
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Add Button with Speed Dial
          SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            openCloseDial: ValueNotifier(isDialOpen),
            backgroundColor: isDialOpen ? Colors.grey[800] : Colors.black,
            foregroundColor: Colors.white,
            activeBackgroundColor: Colors.grey[700],
            activeForegroundColor: Colors.white,
            onOpen: () => setState(() => isDialOpen = true),
            onClose: () => setState(() => isDialOpen = false),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.photo_album),
                label: 'Photo Album',
                onTap: widget.onPickImageFromGallery,
              ),
              SpeedDialChild(
                child: const Icon(Icons.camera),
                label: 'Camera',
                onTap: widget.onPickImageFromCamera,
              ),
            ],
          ),
          const SizedBox(width: 8),

          // Input Field and Send Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(231, 231, 231, 1),
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.questionController,
                      decoration: const InputDecoration(
                        hintText: "Ask a question",
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(111, 111, 111, 1),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: _speechToText.isAvailable
                        ? (_isListening ? _stopListening : _startListening)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _speechToText.isAvailable
                            ? (_isListening ? Colors.red : Colors.black)
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final question = widget.questionController.text.trim();
                      if (question.isNotEmpty) {
                        widget.onSendMessage(question);
                        widget.questionController.clear();
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/send_icon.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
