import 'package:flutter/material.dart';
import '../screens/plant_detail_screen.dart';
import '../l10n/app_localizations.dart';

class UnderwaterPlantsCard extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final int count;

  const UnderwaterPlantsCard({
    super.key,
    required this.plants,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 353,
          child: Text(
            AppLocalizations.of(context).todo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.22,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 353,
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: 20,
          ),
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
                      color: const Color(0xFFD3B400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.water_drop_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context).underwatered,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0x33D4B500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Color(0xFFD3B400),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...plants.asMap().entries.map((entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key == plants.length - 1 ? 0 : 24,
                    ),
                    child: InkWell(
                      onTap: () {
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                              Column(
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
                                  ),
                                ],
                              ),
                            ],
                          ),
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