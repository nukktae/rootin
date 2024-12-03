import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/moisture_history.dart';

class MoistureHistoryService {
  static const String _keyPrefix = 'moisture_history_';
  
  Future<List<MoistureHistory>> getMoistureHistory(int plantId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + plantId.toString();
    
    final historyJson = prefs.getString(key);
    print('History for plant $plantId: $historyJson');
    if (historyJson == null) return [];
    
    final historyList = jsonDecode(historyJson) as List;
    final history = historyList
        .map((item) => MoistureHistory.fromJson(item as Map<String, dynamic>))
        .toList();

    // Sort by timestamp
    history.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    // Keep only last 7 entries
    if (history.length > 7) {
      return history.sublist(history.length - 7);
    }
    
    return history;
  }

  Future<void> storeMoistureReading(
    int plantId, 
    double moisture, 
    {DateTime? timestamp}
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + plantId.toString();
    
    // Get existing history
    List<MoistureHistory> history = await getMoistureHistory(plantId);
    
    // Use provided timestamp or current time
    final now = timestamp ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    final existingTodayReading = history.any((item) {
      final itemDate = DateTime(
        item.timestamp.year,
        item.timestamp.month,
        item.timestamp.day,
      );
      return itemDate.isAtSameMomentAs(today);
    });

    // Only add new reading if we don't have one for today
    if (!existingTodayReading) {
      history.add(MoistureHistory(
        plantId: plantId,
        moisture: moisture,
        timestamp: now,
      ));
      
      // Keep only last 7 days
      history = history.where((item) {
        final diff = now.difference(item.timestamp).inDays;
        return diff <= 7;
      }).toList();
      
      // Sort by timestamp
      history.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      // Save updated history
      final historyJson = history.map((e) => e.toJson()).toList();
      await prefs.setString(key, jsonEncode(historyJson));
    }
  }
} 