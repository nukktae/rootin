class MoistureHistory {
  final int plantId;
  final double moisture;
  final DateTime timestamp;

  MoistureHistory({
    required this.plantId,
    required this.moisture,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'plantId': plantId,
    'moisture': moisture,
    'timestamp': timestamp.toIso8601String(),
  };

  factory MoistureHistory.fromJson(Map<String, dynamic> json) => MoistureHistory(
    plantId: json['plantId'] as int,
    moisture: json['moisture'] as double,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
} 