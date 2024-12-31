import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import '../l10n/app_localizations.dart';

class CareBanner extends StatefulWidget {
  final Function(int) setCurrentIndex;
  final int underwaterCount;

  const CareBanner({
    super.key,
    required this.setCurrentIndex,
    required this.underwaterCount,
  });

  @override
  State<CareBanner> createState() => _CareBannerState();
}

class _CareBannerState extends State<CareBanner> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -4.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.setCurrentIndex(1),
      child: Container(
        width: double.infinity,
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You have ${widget.underwaterCount} ${widget.underwaterCount == 1 ? AppLocalizations.of(context).plant : AppLocalizations.of(context).plants}\n${AppLocalizations.of(context).waitingToBeWatered}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).checkYourWatering,
                        style: const TextStyle(
                          color: Color(0xFF6F6F6F),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF6F6F6F),
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/carebannerlogo.png',
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  dev.log('PNG failed to load: $error');
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.red.withOpacity(0.1),
                    child: const Icon(
                      Icons.error,
                      size: 40,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
