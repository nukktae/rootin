class PlantDetail {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final List<String> careTips;

  PlantDetail({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.careTips,
  });

  factory PlantDetail.fromJson(Map<String, dynamic> json) {
    return PlantDetail(
      id: json['id']?.toString() ?? '0', // Ensures `id` is always a String
      name: json['name'] ?? 'Unknown Plant',
      location: json['location'] ?? 'Unknown Location',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150', // Default image if missing
      careTips: _parseCareTips(json['care_tips']),
    );
  }

  // Helper method to parse care tips, ensuring only strings in the list
  static List<String> _parseCareTips(dynamic careTips) {
    if (careTips is List) {
      return careTips.whereType<String>().toList();
    } else {
      return []; // Return empty list if careTips is not a list or is null
    }
  }
}
