import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import 'name_input_screen.dart';

class AddPlantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> plant;

  const AddPlantDetailScreen({
    super.key,
    required this.plant,
  });

  @override
  State<AddPlantDetailScreen> createState() => _AddPlantDetailScreenState();
}

class _AddPlantDetailScreenState extends State<AddPlantDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Back Button
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffE7E7E7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Content Section
                  Expanded(
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        Text(
                          widget.plant['name'],
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.02,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.plant['subname'],
                          style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 12,
                            letterSpacing: -0.09,
                            color: Color(0xff6F6F6F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: Hero(
                            tag: 'plantHero-${widget.plant['id']}',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.plant['imageUrl'],
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NameInputScreen(
                                plantId: widget.plant['id'],
                                plantName: widget.plant['name'],
                                scientificName: widget.plant['subname'],
                                imageUrl: widget.plant['imageUrl'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).addPlant,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context).searchAgain,
                          style: const TextStyle(
                            color: Color(0xff6F6F6F),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
