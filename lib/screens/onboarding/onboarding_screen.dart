import 'package:flutter/material.dart';
import '../../models/onboarding_content.dart';
import '../../widgets/custom_bottom_navigation_bar.dart';
import '../add_plant_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _floatAnimation;

  final List<OnboardingContent> contents = [
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding0.png',
      title: '',
      description: '',
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding1.png',
      title: 'Tired of guessing when to water?',
      description: "It's harder than it looks,\nbut we're here to help.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding2.png',
      title: 'Watering made simple.',
      description: 'Guide you with precise watering reminders.',
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding3.png',
      title: 'Grow with confidence.',
      description: "Let's nurture happy, thriving plants together.",
    ),
    OnboardingContent(
      image: 'assets/images/onboarding/onboarding4.png',
      title: "Let's start by adding\nyour plants with sensor!",
      description: 'You can scan a photo or search to find\nand add your plants.',
    ),
  ];

  void _navigateToAddPlantScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlantScreen(),
      ),
    );
  }

  Widget _buildFinalScreen() {
    return Stack(
      children: [
        // Main content
        Positioned(
          left: 0,
          right: 0,
          top: 181,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Let's start by adding\nyour plants with sensor!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.22,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  contents[contents.length - 1].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.16,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Circular image container
        Positioned(
          left: 107,
          top: 344,
          child: Container(
            width: 180,
            height: 180,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFE3F3FE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
            ),
            child: Image.asset(
              contents[contents.length - 1].image,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Add plants button
        Positioned(
          left: 20,
          right: 20,
          top: 588,
          child: GestureDetector(
            onTap: _navigateToAddPlantScreen,
            child: Container(
              height: 52,
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Center(
                child: Text(
                  'Add your plants →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.18,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom navigation bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFEEEEEE),
                  width: 1.60,
                ),
              ),
            ),
            child: CustomBottomNavigationBar(
              currentIndex: 0,
              onTap: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3, // Only 3 dots for screens 1-3
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: ShapeDecoration(
            color: (_currentPage - 1) == index // Adjust index to account for screen 0
                ? Colors.black 
                : const Color(0xFFD9D9D9),
            shape: const OvalBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildRegularScreen(int index) {
    if (index == 0) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 350),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnimation.value),
                  child: Image.asset(
                    contents[index].image,
                    width: 200,
                    height: 166,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 260),
        Image.asset(
          contents[index].image,
          width: 250,
          height: 208,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 27),
        if (index != 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  contents[index].title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  contents[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 40),
        if (index != 0) _buildDotIndicators(),
        if (index == 3)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 160, 20, 0),
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  4,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                height: 52,
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.18,
                        ),
                      ),
                      Text(
                        ' →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Add auto-navigation timer
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted && _currentPage == 0) {
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _pageController,
        itemCount: contents.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          if (index == contents.length - 1) {
            return _buildFinalScreen();
          }
          return _buildRegularScreen(index);
        },
      ),
    );
  }
} 