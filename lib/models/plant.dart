class Plant {
  final String id;
  final String plantId;
  final String plantTypeId;
  final String name;
  final String nickname;
  final String plantTypeName;
  final String scientificName;
  final String imageUrl;
  final String description;
  final String category;
  final String status;
  final double currentMoisture;
  final Map<String, double> moistureRange;
  
  // Care info
  final String infoDifficulty;
  final String infoWatering;
  final String infoLight;
  final String infoSoilType;
  final String infoRepotting;
  final String infoToxicity;

  Plant({
    required this.id,
    required this.plantId,
    required this.plantTypeId,
    required this.name,
    required this.nickname,
    required this.plantTypeName,
    required this.scientificName,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.status,
    required this.currentMoisture,
    required this.moistureRange,
    required this.infoDifficulty,
    required this.infoWatering,
    required this.infoLight,
    required this.infoSoilType,
    required this.infoRepotting,
    required this.infoToxicity,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id']?.toString() ?? '',
      plantId: json['plantId']?.toString() ?? '',
      plantTypeId: json['plantTypeId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      plantTypeName: json['plantTypeName']?.toString() ?? '',
      scientificName: json['scientificName']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      currentMoisture: (json['currentMoisture'] as num?)?.toDouble() ?? 0.0,
      moistureRange: _parseMoistureRange(json['moistureRange']),
      infoDifficulty: json['infoDifficulty']?.toString() ?? '',
      infoWatering: json['infoWatering']?.toString() ?? '',
      infoLight: json['infoLight']?.toString() ?? '',
      infoSoilType: json['infoSoilType']?.toString() ?? '',
      infoRepotting: json['infoRepotting']?.toString() ?? '',
      infoToxicity: json['infoToxicity']?.toString() ?? '',
    );
  }

  static Map<String, double> _parseMoistureRange(dynamic json) {
    if (json is Map) {
      return {
        'min': (json['min'] as num?)?.toDouble() ?? 0.0,
        'max': (json['max'] as num?)?.toDouble() ?? 0.0,
      };
    }
    return {'min': 0.0, 'max': 0.0};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'plantTypeId': plantTypeId,
      'name': name,
      'nickname': nickname,
      'plantTypeName': plantTypeName,
      'scientificName': scientificName,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
      'status': status,
      'currentMoisture': currentMoisture,
      'moistureRange': moistureRange,
      'infoDifficulty': infoDifficulty,
      'infoWatering': infoWatering,
      'infoLight': infoLight,
      'infoSoilType': infoSoilType,
      'infoRepotting': infoRepotting,
      'infoToxicity': infoToxicity,
    };
  }
}
