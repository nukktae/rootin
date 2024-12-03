
class DataTransformerService {
  Map<String, dynamic> transformPlantData(Map<String, dynamic> hojunData, Map<String, dynamic> kihoonData) {
    // Ensure both data sets are for the same plant
    if (hojunData['plantId'] != kihoonData['plant_id']) {
      throw Exception('Data mismatch: Plant IDs do not match');
    }

    return {
      'plantId': kihoonData['plant_id'],
      'nickname': kihoonData['plant_name'],
      'plantTypeName': kihoonData['plant_type_name'],
      'scientificName': kihoonData['subname'],
      'category': hojunData['category'],
      'imageUrl': hojunData['imageUrl'],
      'status': hojunData['status'],
      'moisture_range': [
        kihoonData['humidity_min'],
        kihoonData['humidity_max']
      ],
      'current_moisture': hojunData['current_moisture'],
      'lastUpdated': hojunData['lastUpdated'],
      'info_toxicity': hojunData['info_toxicity'],
      'info_difficulty': hojunData['info_difficulty'],
      'info_repotting': hojunData['info_repotting'],
      'info_watering': hojunData['info_watering'],
      'info_light': hojunData['info_light'],
      'info_soil_type': hojunData['info_soil_type'],
      'timestamp': kihoonData['timestamp']
    };
  }

  List<Map<String, dynamic>> combineAndTransformData(
    List<dynamic> hojunData,
    List<dynamic> kihoonData
  ) {
    final Map<int, dynamic> kihoonDataMap = {
      for (var item in kihoonData) 
        item['plant_id']: item
    };

    return hojunData.map((hojunItem) {
      final plantId = hojunItem['plantId'];
      final kihoonItem = kihoonDataMap[plantId];
      
      if (kihoonItem != null) {
        return transformPlantData(hojunItem, kihoonItem);
      }
      
      // If no matching kihoon data, return hojun data with defaults
      return transformPlantData(hojunItem, {
        'plant_id': plantId,
        'plant_name': hojunItem['nickname'],
        'plant_type_name': hojunItem['plantTypeName'],
        'subname': '',
        'humidity_min': hojunItem['moisture_range'][0],
        'humidity_max': hojunItem['moisture_range'][1],
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }).toList();
  }
} 