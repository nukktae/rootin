import 'package:flutter/material.dart';
import '../widgets/chatbot_banner.dart';

class WaterloggedInstructionsScreen extends StatelessWidget {
  const WaterloggedInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button section
              Container(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEEEEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Water-Logged',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'There can be various causes of water-logging. Follow the instructions below and maintain your healthy plant care!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Instructions title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Instructions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Instructions list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildInstructionItem(1, 'Check the pot\'s drainage hole', 
                      'Ensure the drainage holes aren\'t blocked and water can flow freely.'),
                    _buildInstructionItem(2, 'Empty the drip tray',
                      'Remove any standing water from the drip tray to prevent reabsorption.'),
                    _buildInstructionItem(3, 'Try repotting',
                      'If issues persist, consider repotting with fresh, well-draining soil.'),
                    _buildInstructionItem(4, 'Check sensor',
                      'Ensure the sensor is properly placed and functioning correctly.',
                      isWarning: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // AI chat suggestion text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "If you can't find the exact reason, chat with our AI diagnosing and figure out the problems.",
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Chatbot banner
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ChatbotBanner(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(int number, String title, String description, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        backgroundColor: isWarning ? const Color(0xFFFFEBEB) : const Color(0xFFF5F5F5),
        collapsedBackgroundColor: isWarning ? const Color(0xFFFFEBEB) : const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isWarning ? Colors.red : Colors.black,
          ),
          child: isWarning 
            ? const Icon(Icons.warning, color: Colors.white, size: 16)
            : Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6F6F6F),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 