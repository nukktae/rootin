import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool sendNotifications = true;
  bool underwaterReminder = true;
  bool measuringReminder = true;
  bool idealReminder = true;
  bool overwaterReminder = true;
  bool waterloggedReminder = true;

  final NotificationService _notificationService = NotificationService();

  Widget _buildReminderItem({
    required String title,
    required Color iconColor,
    required String iconPath,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 49.33,
                padding: const EdgeInsets.symmetric(horizontal: 10.67, vertical: 8),
                decoration: ShapeDecoration(
                  color: iconColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.33),
                  ),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  width: 28,
                  height: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF34C759),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(12),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFEEEEEE),
                        shape: CircleBorder(),
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context).settings,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.28,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context).notifications,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 49.33,
                          padding: const EdgeInsets.symmetric(horizontal: 10.67, vertical: 8),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEEEEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.33),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFF757575),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context).sendMeNotifications,
                          style: const TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: sendNotifications,
                      onChanged: (value) {
                        setState(() {
                          sendNotifications = value;
                          if (!value) {
                            underwaterReminder = false;
                            measuringReminder = false;
                            idealReminder = false;
                            overwaterReminder = false;
                            waterloggedReminder = false;
                          }
                        });
                      },
                      activeColor: const Color(0xFF34C759),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context).wateringReminders,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    _buildReminderItem(
                      title: AppLocalizations.of(context).underwaterReminder,
                      iconColor: const Color(0xFFD3B400),
                      iconPath: 'assets/icons/status_underwater.svg',
                      value: underwaterReminder && sendNotifications,
                      onChanged: sendNotifications ? (value) {
                        setState(() {
                          underwaterReminder = value;
                        });
                      } : null,
                    ),
                    const SizedBox(height: 16),
                    _buildReminderItem(
                      title: AppLocalizations.of(context).measuringReminder,
                      iconColor: const Color(0xFF757575),
                      iconPath: 'assets/icons/status_measuring.svg',
                      value: measuringReminder && sendNotifications,
                      onChanged: sendNotifications ? (value) {
                        setState(() {
                          measuringReminder = value;
                        });
                      } : null,
                    ),
                    const SizedBox(height: 16),
                    _buildReminderItem(
                      title: AppLocalizations.of(context).idealReminder,
                      iconColor: const Color(0xFF73C2FB),
                      iconPath: 'assets/icons/status_ideal.svg',
                      value: idealReminder && sendNotifications,
                      onChanged: sendNotifications ? (value) {
                        setState(() {
                          idealReminder = value;
                        });
                      } : null,
                    ),
                    const SizedBox(height: 16),
                    _buildReminderItem(
                      title: AppLocalizations.of(context).overwaterReminder,
                      iconColor: const Color(0xFF24494E),
                      iconPath: 'assets/icons/status_overwater.svg',
                      value: overwaterReminder && sendNotifications,
                      onChanged: sendNotifications ? (value) {
                        setState(() {
                          overwaterReminder = value;
                        });
                      } : null,
                    ),
                    const SizedBox(height: 16),
                    _buildReminderItem(
                      title: AppLocalizations.of(context).waterloggedReminder,
                      iconColor: Colors.black,
                      iconPath: 'assets/icons/status_waterlogged.svg',
                      value: waterloggedReminder && sendNotifications,
                      onChanged: sendNotifications ? (value) {
                        setState(() {
                          waterloggedReminder = value;
                        });
                      } : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 