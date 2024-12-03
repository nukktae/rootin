import 'package:flutter/material.dart';
import 'package:fuckyou/screens/ai_chatbot_screen.dart';

class ContentcontainerWidget extends StatelessWidget {
  const ContentcontainerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(66, 157, 255, 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chat with our AI diagnosing!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ask our Chatbot and resolve your curiosities.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // Navigate to AIChatbotScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIChatbotScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Go to Chatbot',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
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
