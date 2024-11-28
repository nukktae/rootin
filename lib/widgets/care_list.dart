import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'care_plant_card.dart';
import 'status_icon.dart';

class CareList extends StatefulWidget {
  const CareList({super.key});

  @override
  _CareListState createState() => _CareListState();
}

class _CareListState extends State<CareList> {
  List<Map<String, dynamic>> inProgressPlants = [];
  List<Map<String, dynamic>> donePlants = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(Uri.parse('https://api.example.com/plants')); // Replace with your API URL
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final List<Map<String, dynamic>> plants = List<Map<String, dynamic>>.from(data);

        // Filter plants based on status
        setState(() {
          inProgressPlants = plants.where((plant) => plant['status'] != 'IDEAL').toList();
          donePlants = plants.where((plant) => plant['status'] == 'IDEAL').toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('An error occurred. Please try again.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Done Section
            if (donePlants.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    StatusIcon(status: 'IDEAL'),
                    SizedBox(width: 8),
                    Text('Done', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: donePlants.length,
                itemBuilder: (context, index) {
                  final plant = donePlants[index];
                  return CarePlantCard(
                    plantName: plant['plantTypeName'],
                    location: plant['category'],
                    imageUrl: plant['imageUrl'],
                    lastUpdated: 'Recently', // Adjust based on data if available
                  );
                },
              ),
            ] else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('No completed tasks in "Done".'),
              ),

            // In Progress Section
            if (inProgressPlants.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    StatusIcon(status: 'UNDERWATER'), // Icon may vary based on your design
                    SizedBox(width: 8),
                    Text('In Progress', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: inProgressPlants.length,
                itemBuilder: (context, index) {
                  final plant = inProgressPlants[index];
                  return CarePlantCard(
                    plantName: plant['plantTypeName'],
                    location: plant['category'],
                    imageUrl: plant['imageUrl'],
                    lastUpdated: '2 days ago', // Adjust based on data if available
                  );
                },
              ),
            ] else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('No tasks in progress.'),
              ),
          ],
        ),
      ),
    );
  }
}
