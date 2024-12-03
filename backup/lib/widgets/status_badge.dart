import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: ShapeDecoration(
        color: _getStatusColor(status),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: SvgPicture.asset(
        _getStatusIcon(status),
        width: 18,
        height: 18,
        color: Colors.white,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ideal':
        return const Color(0xFF73C2FB);
      case 'underwatered':
        return const Color(0xFFD3B400);
      case 'overwatered':
        return const Color(0xFF24494E);
      default:
        return const Color(0xFFD9D9D9);
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'ideal':
        return 'assets/icons/status_ideal.svg';
      case 'underwatered':
        return 'assets/icons/status_underwatered.svg';
      case 'overwatered':
        return 'assets/icons/status_overwatered.svg';
      default:
        return 'assets/icons/status_unknown.svg';
    }
  }
} 