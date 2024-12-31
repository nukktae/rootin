class HumidityReading {
  final double value;
  final DateTime timestamp;
  
  HumidityReading({
    required this.value,
    required this.timestamp,
  });

  factory HumidityReading.fromJson(Map<String, dynamic> json) {
    return HumidityReading(
      value: (json['event_values'][0] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }
}

List<HumidityReading> parseHumidityReadings(List<dynamic> json) {
  return json.map((reading) => HumidityReading.fromJson(reading)).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
} 