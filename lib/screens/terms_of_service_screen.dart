import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          AppLocalizations.of(context).termsOfService,
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
              title: 'Acceptance of Terms',
              content: '''
By accessing and using the Rootin application, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Use of Service',
              content: '''
• You must be at least 13 years old to use this service
• You are responsible for maintaining the security of your account
• You agree not to use the service for any illegal purposes
• You agree not to interfere with or disrupt the service
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'User Content',
              content: '''
• You retain ownership of any content you submit to the service
• You grant Rootin a license to use, store, and display your content
• You are responsible for any content you submit
• We reserve the right to remove any content that violates these terms
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Service Modifications',
              content: '''
We reserve the right to:
• Modify or discontinue any part of the service
• Update these terms at any time
• Change our pricing structure with notice
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Limitation of Liability',
              content: '''
• The service is provided "as is" without warranties
• We are not liable for any indirect, incidental, or consequential damages
• Our liability is limited to the amount paid for the service
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Termination',
              content: '''
We may terminate or suspend your account at any time for violations of these terms. Upon termination, your right to use the service will immediately cease.
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Governing Law',
              content: '''
These terms are governed by the laws of the Republic of Korea. Any disputes shall be resolved in the courts of Seoul, Korea.
              ''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Contact',
              content: '''
If you have any questions about these Terms of Service, please contact us at:
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