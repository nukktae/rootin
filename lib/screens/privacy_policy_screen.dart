import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context).privacyPolicy,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Information We Collect',
              content: '''
• Personal Information: When you create an account, we collect your email address and basic profile information.
• Device Information: We collect information about your device, including device type, operating system, and unique device identifiers.
• Usage Data: We collect data about how you use our app, including plant care records and sensor data.
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'How We Use Your Information',
              content: '''
• To provide and maintain our service
• To notify you about changes to our service
• To provide customer support
• To gather analysis or valuable information to improve our service
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Data Security',
              content: '''
We implement appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction.
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Your Rights',
              content: '''
You have the right to:
• Access your personal data
• Correct inaccurate data
• Request deletion of your data
• Object to data processing
• Export your data
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Contact Us',
              content: '''
If you have any questions about this Privacy Policy, please contact us at:
support@rootin.me
              ''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF666666),
            height: 1.5,
          ),
        ),
      ],
    );
  }
} 