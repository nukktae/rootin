import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'dart:developer' as dev;
import 'package:network_info_plus/network_info_plus.dart';

class WifiService {
  static const MethodChannel _channel = MethodChannel('com.example.app/wifi');
  static final _networkInfo = NetworkInfo();
  
  static Future<List<String>> getAvailableNetworks() async {
    try {
      // First get current network
      final currentNetwork = await _networkInfo.getWifiName();
      List<String> networks = [];
      
      if (currentNetwork != null) {
        networks.add(currentNetwork.replaceAll('"', ''));
      }
      
      // Then get other networks through platform channel
      if (Platform.isIOS) {
        try {
          final List<dynamic> result = await _channel.invokeMethod('getWifiNetworks');
          networks.addAll(result.cast<String>());
        } catch (e) {
          dev.log('Error getting networks from platform channel: $e');
          // Fallback to BLE if platform channel fails
          return networks;
        }
      }
      
      // Remove duplicates and empty networks
      networks = networks
          .where((network) => network.isNotEmpty)
          .toSet()
          .toList();
          
      dev.log('Found WiFi networks: $networks');
      return networks;
      
    } catch (e) {
      dev.log('Error getting WiFi networks: $e');
      return [];
    }
  }
} 