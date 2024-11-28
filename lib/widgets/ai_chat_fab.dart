 import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/ai_chatbot_screen.dart';

class AIChatFAB extends StatelessWidget {
  const AIChatFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatbotScreen()),
          );
        },
        backgroundColor: const Color(0xFF04ABB0),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x1909ABB0),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x1609ABB0),
                blurRadius: 8,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x0C09ABB0),
                blurRadius: 10,
                offset: Offset(0, 17),
              ),
              BoxShadow(
                color: Color(0x0209ABB0),
                blurRadius: 12,
                offset: Offset(0, 31),
              ),
              BoxShadow(
                color: Color(0x0009ABB0),
                blurRadius: 13,
                offset: Offset(0, 48),
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/icons/plantai_nav.svg',
            width: 32,
            height: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}