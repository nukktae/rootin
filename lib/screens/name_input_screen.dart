import 'package:flutter/material.dart';
import 'site_selection_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';

class NameInputScreen extends StatefulWidget {
  final String plantId;
  final String plantName;
  final String scientificName;
  final String imageUrl;

  const NameInputScreen({
    Key? key,
    required this.plantId,
    required this.plantName,
    required this.scientificName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;
  static const int maxCharacters = 20;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _nameController.addListener(() {
      setState(() {
        bool newIsValid = _nameController.text.isNotEmpty && 
                         _nameController.text.length <= maxCharacters;
        _isButtonEnabled = newIsValid;
        
        // Animate the checkmark based on validity
        if (newIsValid) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final plantNickname = _nameController.text.trim();
    
    if (plantNickname.isEmpty) {
      debugPrint("Plant nickname is empty!");
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SiteSelectionScreen(
            id: widget.plantId,
            name: plantNickname,  // Pass the nickname to site selection
            subname: widget.scientificName,
            imageUrl: widget.imageUrl,
          ),
        ),
      );
    }
  }

  bool get _isValidInput => _nameController.text.isNotEmpty && 
                           _nameController.text.length <= maxCharacters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 55.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFE7E7E7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/arrow.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Plant Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imageUrl,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _placeholderImage();
                      },
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Text sections
                  Text(
                    AppLocalizations.of(context).nameYourPlant,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).nameWithinCharacters,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input Field
                  Container(
                    width: 263,
                    height: 48,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE8E8E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Stack(
                      children: [
                        TextField(
                          controller: _nameController,
                          maxLength: maxCharacters,
                          style: const TextStyle(
                            color: Color(0xFF5E5E5E),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.16,
                          ),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).plantNickname,
                            hintStyle: const TextStyle(
                              color: Color(0xFF5E5E5E),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.16,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            counterText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                          ),
                        ),
                        if (_isValidInput)
                          Positioned(
                            right: 12,
                            top: 12,
                            child: FadeTransition(
                              opacity: _scaleAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Color(0xFF0E8345), // Updated to the exact green color
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled ? _onContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isButtonEnabled ? Colors.black : Colors.grey[300],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).continueText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Placeholder image widget
  Widget _placeholderImage() {
    return Container(
      height: 150,
      width: 150,
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}
