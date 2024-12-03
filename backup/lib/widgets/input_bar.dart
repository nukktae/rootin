import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
