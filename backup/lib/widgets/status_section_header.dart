import 'package:flutter/material.dart';

class StatusSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final String? subtitle;

  const StatusSectionHeader({
    super.key,
    required this.title,
    required this.count,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle!,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }
}
