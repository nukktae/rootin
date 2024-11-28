import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/plant_detail_screen.dart';

class InProgressPlantsCard extends StatelessWidget {
  final List<Map<String, dynamic>> plants;
  final int count;

  const InProgressPlantsCard({
    super.key,
    required this.plants,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 353,
          child: Text(
            'In progress',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0.06,
              letterSpacing: -0.22,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 353,
          padding: const EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: 28,
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
                      color: const Color(0xFF757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/status_measuring.svg',
                          width: 20,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Measuring',
                          style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(horizontal: 13.5, vertical: 6),
                    decoration: ShapeDecoration(
                      color: const Color(0x33757575),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Color(0xFF757575),
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
                  bottom: entry.key < plants.length - 1 ? 24 : 0,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantDetailScreen(
                          plantTypeId: entry.value['plantId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    entry.value['location'] ?? 'Location',
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