import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/plant_detail_screen.dart';
import '../l10n/app_localizations.dart';

class DonePlantsCard extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final int count;

  const DonePlantsCard({
    super.key,
    required this.plants,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).done,
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
          AppLocalizations.of(context).movesToHistory,
          style: const TextStyle(
            color: Color(0xFF757575),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 353,
          padding: const EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF73C2FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/status_ideal.svg',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context).ideal,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0x3373C2FB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Color(0xFF73C2FB),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...plants.asMap().entries.map((entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < plants.length - 1 ? 24 : 0,
                ),
                child: InkWell(
                  onTap: () {
                    print('Navigating to plant with typeId: ${entry.value['plantTypeId']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailScreen(
                          plantTypeId: entry.value['plantTypeId']?.toString() ?? '',
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                entry.value['imageUrl'] ?? '',
                                width: 58,
                                height: 58,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.value['name'] ?? 'Plant name',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.28,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppLocalizations.of(context).in_} ${entry.value['location'].toString().split('/').last}',
                                    style: const TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.24,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ],
          ),
        ),
      ],
    );
  }
} 